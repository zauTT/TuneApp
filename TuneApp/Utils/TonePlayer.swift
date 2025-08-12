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
    private var engine: AVAudioEngine?

    func play(frequency: Double, duration: Double) {
        stop()
        let engine = AVAudioEngine()
        let player = AVAudioPlayerNode()
        engine.attach(player)

        let mainMixer = engine.mainMixerNode
        engine.connect(player, to: mainMixer, format: nil)

        let sampleRate = 44100
        let length = Int(Double(sampleRate) * duration)
        let buffer = AVAudioPCMBuffer(pcmFormat: AVAudioFormat(standardFormatWithSampleRate: Double(sampleRate), channels: 1)!, frameCapacity: AVAudioFrameCount(length))!
        buffer.frameLength = AVAudioFrameCount(length)

        let theta = 2.0 * Double.pi * frequency / Double(sampleRate)
        let ptr = buffer.floatChannelData![0]
        for i in 0..<length {
            ptr[i] = Float(sin(theta * Double(i)) * 0.5)
        }

        player.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)

        do {
            try engine.start()
            player.play()
            self.engine = engine
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.stop()
            }
        } catch {
            print("TonePlayer failed: \(error)")
        }
    }

    func stop() {
        engine?.stop()
        engine = nil
    }
}