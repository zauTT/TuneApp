//
//  MainMenuViewController 2.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 16.08.25.
//


import UIKit

final class MainMenuViewController: UIViewController {
    private let autoButton = UIButton(type: .system)
    private let manualButton = UIButton(type: .system)
    private let metronomeButton = UIButton(type: .system)
    
    private let autoTuneLabel = UILabel()
    private let autoImageView = UIImageView()
    private let manualLabel = UILabel()
    private let manualImageView = UIImageView()
    private let metronomeLabel = UILabel()
    private let metronomeImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "TuneApp"
        
        setupAutoTuneButton()
        setupManualButton()
        setupMetronomeButton()

        autoButton.addTarget(self, action: #selector(openAuto), for: .touchUpInside)
        manualButton.addTarget(self, action: #selector(openManual), for: .touchUpInside)
        metronomeButton.addTarget(self, action: #selector(openMetronome), for: .touchUpInside)
    }
    
    private func setupAutoTuneButton() {
        view.addSubview(autoButton)
        autoButton.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = UIImage(named: "GuitarMinimal") {
            autoImageView.image = image
        }
        
        autoButton.backgroundColor = .systemBlue
        autoButton.layer.cornerRadius = 8
        autoButton.clipsToBounds = true
        
        autoButton.addSubview(autoImageView)
        autoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        autoButton.addSubview(autoTuneLabel)
        autoTuneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        autoTuneLabel.text = "Auto Tune"
        autoTuneLabel.textColor = .white
        autoTuneLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        
        
        NSLayoutConstraint.activate([
            autoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            autoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            autoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            autoButton.heightAnchor.constraint(equalToConstant: 200),
            
            autoImageView.topAnchor.constraint(equalTo: autoButton.topAnchor, constant: 5),
            autoImageView.bottomAnchor.constraint(equalTo: autoButton.bottomAnchor, constant: -5),
            autoImageView.leadingAnchor.constraint(equalTo: autoButton.leadingAnchor, constant: 5),
            autoImageView.widthAnchor.constraint(equalToConstant: 190),
            
            autoTuneLabel.trailingAnchor.constraint(equalTo: autoButton.trailingAnchor, constant: -20),
            autoTuneLabel.bottomAnchor.constraint(equalTo: autoButton.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupManualButton() {
        view.addSubview(manualButton)
        manualButton.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = UIImage(named: "minimalEar") {
            manualImageView.image = image
        }
        
        manualButton.backgroundColor = .systemGreen
        manualButton.layer.cornerRadius = 8
        manualButton.clipsToBounds = true
        
        manualButton.addSubview(manualImageView)
        manualImageView.translatesAutoresizingMaskIntoConstraints = false
        
        manualButton.addSubview(manualLabel)
        manualLabel.translatesAutoresizingMaskIntoConstraints = false
        
        manualLabel.text = "Tune by Ear"
        manualLabel.textColor = .white
        manualLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        
        NSLayoutConstraint.activate([
            manualButton.topAnchor.constraint(equalTo: autoButton.bottomAnchor, constant: 20),
            manualButton.leadingAnchor.constraint(equalTo: autoButton.leadingAnchor),
            manualButton.trailingAnchor.constraint(equalTo: autoButton.trailingAnchor),
            manualButton.heightAnchor.constraint(equalToConstant: 120),
            
            manualImageView.topAnchor.constraint(equalTo: manualButton.topAnchor, constant: 5),
            manualImageView.bottomAnchor.constraint(equalTo: manualButton.bottomAnchor, constant: -5),
            manualImageView.leadingAnchor.constraint(equalTo: manualButton.leadingAnchor, constant: 30),
            manualImageView.widthAnchor.constraint(equalToConstant: 90),
            
            manualLabel.trailingAnchor.constraint(equalTo: manualButton.trailingAnchor, constant: -10),
            manualLabel.bottomAnchor.constraint(equalTo: manualButton.bottomAnchor, constant: -10),
        ])
    }
    
    private func setupMetronomeButton() {
        view.addSubview(metronomeButton)
        metronomeButton.translatesAutoresizingMaskIntoConstraints = false
        
        if let image = UIImage(named: "metronome") {
            metronomeImageView.image = image
        }
        
        metronomeButton.backgroundColor = .systemCyan
        metronomeButton.layer.cornerRadius = 8
        metronomeButton.clipsToBounds = true
        
        metronomeButton.addSubview(metronomeImageView)
        metronomeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        metronomeButton.addSubview(metronomeLabel)
        metronomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        metronomeLabel.text = "Metronome"
        metronomeLabel.textColor = .white
        metronomeLabel.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        
        NSLayoutConstraint.activate([
            metronomeButton.topAnchor.constraint(equalTo: manualButton.bottomAnchor, constant: 25),
            metronomeButton.trailingAnchor.constraint(equalTo: manualButton.trailingAnchor),
            metronomeButton.leadingAnchor.constraint(equalTo: manualButton.leadingAnchor),
            metronomeButton.heightAnchor.constraint(equalTo: manualButton.heightAnchor),
            
            metronomeImageView.topAnchor.constraint(equalTo: metronomeButton.topAnchor, constant: 5),
            metronomeImageView.bottomAnchor.constraint(equalTo: metronomeButton.bottomAnchor, constant: -5),
            metronomeImageView.leadingAnchor.constraint(equalTo: metronomeButton.leadingAnchor, constant: 30),
            metronomeImageView.widthAnchor.constraint(equalToConstant: 90),
            
            metronomeLabel.trailingAnchor.constraint(equalTo: metronomeButton.trailingAnchor, constant: -10),
            metronomeLabel.bottomAnchor.constraint(equalTo: metronomeButton.bottomAnchor, constant: -10),
        ])
    }
    
    @objc private func openAuto() {
        let vc = AutoTuneViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func openManual() {
        let vc = ManualTuneViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func openMetronome() {
        let vc = MetronomeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
