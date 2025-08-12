//
//  MainMenuViewController.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 12.08.25.
//


import UIKit

final class MainMenuViewController: UIViewController {
    private let autoButton = UIButton(type: .system)
    private let manualButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "TuneApp"

        autoButton.setTitle("Auto Tune", for: .normal)
        manualButton.setTitle("Manual Tune", for: .normal)

        autoButton.addTarget(self, action: #selector(openAuto), for: .touchUpInside)
        manualButton.addTarget(self, action: #selector(openManual), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [autoButton, manualButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            autoButton.widthAnchor.constraint(equalToConstant: 220),
            manualButton.widthAnchor.constraint(equalToConstant: 220),
            autoButton.heightAnchor.constraint(equalToConstant: 60),
            manualButton.heightAnchor.constraint(equalToConstant: 60),
        ])

        autoButton.backgroundColor = .systemBlue
        autoButton.tintColor = .white
        manualButton.backgroundColor = .systemGreen
        manualButton.tintColor = .white
        autoButton.layer.cornerRadius = 12
        manualButton.layer.cornerRadius = 12
    }

    @objc private func openAuto() {
        let vc = AutoTuneViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func openManual() {
        let vc = ManualTuneViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}