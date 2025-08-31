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
    
    private let clickButton = MetronomeViewController.makeSoundButton(title: "Click")
    private let clapButton = MetronomeViewController.makeSoundButton(title: "Clap")
    private let snareButton = MetronomeViewController.makeSoundButton(title: "Snare")
    
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private var currentSound: String = "click"
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
        
        clickButton.addTarget(self, action: #selector(selectClick), for: .touchUpInside)
        clapButton.addTarget(self, action: #selector(comingSoonTapped), for: .touchUpInside)
        snareButton.addTarget(self, action: #selector(comingSoonTapped), for: .touchUpInside)
        
        loadSound(named: currentSound)
        highlightSelectedButton(clickButton)
    }
    
    private static func makeSoundButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }
    
    private func setupLayout() {
        view.addSubview(beatCircle)
        view.addSubview(bpmLabel)
        view.addSubview(bpmSlider)
        view.addSubview(startStopButton)
        
        let soundStack = UIStackView(arrangedSubviews: [clickButton, clapButton, snareButton])
        soundStack.axis = .horizontal
        soundStack.spacing = 20
        soundStack.alignment = .center
        soundStack.distribution = .equalSpacing
        view.addSubview(soundStack)
        
        beatCircle.translatesAutoresizingMaskIntoConstraints = false
        bpmLabel.translatesAutoresizingMaskIntoConstraints = false
        bpmSlider.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        soundStack.translatesAutoresizingMaskIntoConstraints = false
        
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
            startStopButton.heightAnchor.constraint(equalToConstant: 50),
            
            soundStack.topAnchor.constraint(equalTo: startStopButton.bottomAnchor, constant: 100),
            soundStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let interval = 60.0 / Double(bpm)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.playClick()
        }
    }
    
    private func stopMetronome() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
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
    
    // MARK: - Sound Handling
    
    @objc private func selectClick() {
        currentSound = "click"
        loadSound(named: currentSound)
        highlightSelectedButton(clickButton)
    }

    @objc private func comingSoonTapped(_ sender: UIButton) {
        showAlert(title: "Coming Soon", message: "More sounds will be available in a future update.")
    }
    
    private func highlightSelectedButton(_ selected: UIButton) {
        [clickButton, clapButton, snareButton].forEach { btn in
            btn.backgroundColor = .secondarySystemBackground
            btn.setTitleColor(.label, for: .normal)
        }
        selected.backgroundColor = .systemCyan
        selected.setTitleColor(.white, for: .normal)
    }
    
    private func loadSound(named: String) {
        if let url = Bundle.main.url(forResource: named, withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        } else {
            print("⚠️ Sound file \(named).wav not found")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
