//
//  TonePlayer.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 12.08.25.
//


import Foundation
import AVFoundation

final class TonePlayer {
    static let shared = TonePlayer()

    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()

    private init() {
        engine.attach(player)
        
        let mixer = engine.mainMixerNode
        let format = mixer.outputFormat(forBus: 0)
        engine.connect(player, to: mixer, format: format)

        do {
            try engine.start()
        } catch {
            print("TonePlayer engine start failed: \(error)")
        }
    }

    /// Play a simple sine tone that matches the output format's channel count
    func play(frequency: Double, duration: Double) {
        stop()

        let mixer = engine.mainMixerNode
        let format = mixer.outputFormat(forBus: 0)
        let sampleRate = format.sampleRate
        guard sampleRate > 0 else {
            print("TonePlayer: invalid sample rate (0 Hz)")
            return
        }

        let channels = Int(format.channelCount)
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            print("TonePlayer: failed to allocate buffer")
            return
        }
        buffer.frameLength = frameCount

        let theta = 2.0 * Double.pi * frequency / sampleRate
        if let channelData = buffer.floatChannelData {
            for ch in 0..<channels {
                let ptr = channelData[ch]
                for i in 0..<Int(frameCount) {
                    ptr[i] = Float(sin(theta * Double(i)) * 0.5)
                }
            }
        }

        player.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
        player.play()

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.stop()
        }
    }

    func stop() {
        player.stop()
    }
}
