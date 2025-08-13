//
//  PitchDetectionService.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 12.08.25.
//


import Foundation
import AVFoundation
import Accelerate

/// Simple pitch detection service using AVAudioEngine and an autocorrelation method.
final class PitchDetectionService {
    private let engine = AVAudioEngine()
    private var inputNode: AVAudioInputNode? { engine.inputNode }
    private let sampleRate: Double
    private var isRunning = false

    /// callback delivered on main queue with detected frequency (Hz)
    var onFrequencyDetected: ((Double) -> Void)?

    init() {
        let hwFormat = engine.inputNode.inputFormat(forBus: 0)
        sampleRate = hwFormat.sampleRate
    }

    func start() throws {
        guard !isRunning else { return }

        let input = engine.inputNode
        let format = input.inputFormat(forBus: 0)

        input.installTap(onBus: 0, bufferSize: 4096, format: format) { [weak self] buffer, _ in
            guard let strong = self else { return }
            let channelData = buffer.floatChannelData![0]
            let frameLength = Int(buffer.frameLength)
            
            var samples = [Double](repeating: 0, count: frameLength)
            for i in 0..<frameLength { samples[i] = Double(channelData[i]) }

            if let freq = strong.autoCorrelate(samples: samples, sampleRate: Int(strong.sampleRate)) {
                DispatchQueue.main.async {
                    strong.onFrequencyDetected?(freq)
                }
            }
        }

        engine.prepare()
        try engine.start()
        isRunning = true
    }

    func stop() {
        guard isRunning else { return }
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        isRunning = false
    }

    deinit {
        stop()
    }

    // MARK: - Autocorrelation-based pitch detection
    private func autoCorrelate(samples: [Double], sampleRate: Int) -> Double? {
        let n = samples.count
        if n == 0 { return nil }
        
        var mean = 0.0
        vDSP_meanvD(samples, 1, &mean, vDSP_Length(n))
        var normalized = samples
        var negMean = -mean
        vDSP_vsaddD(samples, 1, &negMean, &normalized, 1, vDSP_Length(n))
        
        var bestOffset = 0
        var bestCorrelation = 0.0
        let maxOffset = min(2000, n / 2)

        for offset in 20..<maxOffset {
            var correlation = 0.0
            
            vDSP_dotprD(normalized, 1, Array(normalized[offset..<n]), 1, &correlation, vDSP_Length(n - offset))

            if correlation > bestCorrelation {
                bestCorrelation = correlation
                bestOffset = offset
            }
        }

        if bestOffset == 0 { return nil }

        let frequency = Double(sampleRate) / Double(bestOffset)
        
        if frequency < 50 || frequency > 2000 { return nil }
        return frequency
    }
}
