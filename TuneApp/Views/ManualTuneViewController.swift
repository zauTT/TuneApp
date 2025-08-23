//
//  ManualTuneViewController.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 12.08.25.
//


import UIKit
import AVFoundation

final class ManualTuneViewController: UIViewController {
    private let strings = ["Low E","A","D","G","B","High E"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Manual Tune"
        
        setupUI()
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func setupUI() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        for s in strings {
            let btn = UIButton(type: .system)
            btn.setTitle(s, for: .normal)
            btn.heightAnchor.constraint(equalToConstant: 52).isActive = true
            btn.layer.cornerRadius = 10
            btn.backgroundColor = .secondarySystemBackground
            btn.addTarget(self, action: #selector(playString(_:)), for: .touchUpInside)
            stack.addArrangedSubview(btn)
        }
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func playString(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }
        let freq = Tuning.standardGuitarFrequencies[title] ?? 440.0
        TonePlayer.shared.play(frequency: freq, duration: 1.5)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        UIView.animate(withDuration: 0.1, animations: {
            sender.alpha = 0.7
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.alpha = 1.0
            }
        }
    }
    
    @objc private func openSettings() {
        let settings = SettingsViewController()
        settings.modalPresentationStyle = .pageSheet
        if let sheet = settings.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.95
            })]
            sheet.preferredCornerRadius = 12
        }
        present(settings, animated: true)
    }
}
