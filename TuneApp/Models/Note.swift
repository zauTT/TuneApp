//
//  Note.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 12.08.25.
//


import Foundation

struct Note {
    let name: String
    let frequency: Double
}

struct NoteUtilities {
    static func frequencyToMIDINote(_ freq: Double) -> Double {
        return 69 + 12 * log2(freq / 440.0)
    }
    
    static func midiNoteToName(_ midi: Int) -> String {
        let names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let name = names[midi % 12]
        let octave = (midi / 12) - 1
        return "\(name) - \(octave)"
    }
    
    static func closestNote(for frequency: Double) -> (name: String, targetFreq: Double, midi: Int)? {
        guard frequency > 0 else { return nil }
        let midiFloat = frequencyToMIDINote(frequency)
        let midiRound = Int(round(midiFloat))
        let name = midiNoteToName(midiRound)
        let targetFreq = 440.0 * pow(2.0, (Double(midiRound) - 69.0) / 12.0)
        return (name, targetFreq, midiRound)
    }
    
    static func centsDifference(frequency: Double, target: Double) -> Double {
        guard frequency > 0, target > 0 else { return 0 }
        return 1200 * log2(frequency / target)
    }
}


