//
//  SamplePlayer.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 23.08.25.
//

import Foundation
import AVFoundation

final class SamplePlayer {
    static let shared = SamplePlayer()
    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func playSample(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            print("SamplePlayer: file \(name).wav not found")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("SamplePlayer: error playing \(name) - \(error)")
        }
    }
}
