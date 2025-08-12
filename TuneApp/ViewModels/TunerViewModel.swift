//
//  TunerViewModel.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 12.08.25.
//


import Foundation
import AVFoundation

final class TunerViewModel {
    private let pitchService = PitchDetectionService()

    var onUpdate: ((String, String, Double) -> Void)?

    init() {
        pitchService.onFrequencyDetected = { [weak self] freq in
            self?.processFrequency(freq)
        }
    }

    func start() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
            try pitchService.start()
        } catch {
            print("Failed to start pitch service: \(error)")
        }
    }

    func stop() {
        pitchService.stop()
        try? AVAudioSession.sharedInstance().setActive(false)
    }

    private func processFrequency(_ freq: Double) {
        guard let closest = NoteUtilities.closestNote(for: freq) else { return }
        let cents = NoteUtilities.centsDifference(frequency: freq, target: closest.targetFreq)
        let freqStr = String(format: "%.2f Hz", freq)
        onUpdate?(closest.name, freqStr, cents)
    }
}
