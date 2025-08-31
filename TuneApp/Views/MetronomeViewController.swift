//
//  MetronomeViewController.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 24.08.25.
//

import UIKit
import AVFoundation

final class MetronomeViewController: UIViewController {
    
    private let beatCircle: UIView = {
        let v = UIView()
        v.backgroundColor = .systemCyan
        v.alpha = 0.8
        v.layer.cornerRadius = 100
        return v
    }()
    
    private let bpmLabel: UILabel = {
        let label = UILabel()
        label.text = "BPM: 100"
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let bpmSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 40
        slider.maximumValue = 240
        slider.value = 100
        return slider
    }()
    
    private let startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .systemCyan
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private var bpm: Int = 100 {
        didSet {
            bpmLabel.text = "BPM: \(bpm)"
            if timer != nil {
                startMetronome()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        
        bpmSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        startStopButton.addTarget(self, action: #selector(toggleMetronome), for: .touchUpInside)
        
        if let soundURL = Bundle.main.url(forResource: "click", withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        }
    }
    
    private func setupLayout() {
        view.addSubview(beatCircle)
        view.addSubview(bpmLabel)
        view.addSubview(bpmSlider)
        view.addSubview(startStopButton)
        
        beatCircle.translatesAutoresizingMaskIntoConstraints = false
        bpmLabel.translatesAutoresizingMaskIntoConstraints = false
        bpmSlider.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            beatCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            beatCircle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            beatCircle.widthAnchor.constraint(equalToConstant: 200),
            beatCircle.heightAnchor.constraint(equalToConstant: 200),
            
            bpmLabel.topAnchor.constraint(equalTo: beatCircle.bottomAnchor, constant: 100),
            bpmLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bpmSlider.topAnchor.constraint(equalTo: bpmLabel.bottomAnchor, constant: 30),
            bpmSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            bpmSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            startStopButton.topAnchor.constraint(equalTo: bpmSlider.bottomAnchor, constant: 40),
            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startStopButton.widthAnchor.constraint(equalToConstant: 120),
            startStopButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func sliderChanged() {
        bpm = Int(bpmSlider.value)
    }
    
    @objc private func toggleMetronome() {
        if timer == nil {
            startMetronome()
            startStopButton.setTitle("Stop", for: .normal)
        } else {
            stopMetronome()
            startStopButton.setTitle("Start", for: .normal)
        }
    }
    
    private func startMetronome() {
        stopMetronome()
        let interval = 60.0 / Double(bpm)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.playClick()
        }
    }
    
    private func stopMetronome() {
        timer?.invalidate()
        timer = nil
    }
    
    private func playClick() {
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
        animateBeatCircle()
    }
    
    private func animateBeatCircle() {
        UIView.animate(withDuration: 0.1,
                       animations: {
                           self.beatCircle.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                       }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.beatCircle.transform = .identity
            }
        }
    }
}
