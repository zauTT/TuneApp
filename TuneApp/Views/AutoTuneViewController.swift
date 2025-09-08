//
//  AutoTuneViewController.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 12.08.25.
//


import UIKit

final class AutoTuneViewController: UIViewController {
    
//    private let needleView = NeedleView()
    private let ballView = BallView()

    private let viewModel = TunerViewModel()
    
    private let noteLabel = UILabel()
    private let freqLabel = UILabel()
    private let centsLabel = UILabel()
    private let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Auto Tune"

        setupUI()

        viewModel.onUpdate = { [weak self] name, freq, cents in
            self?.noteLabel.text = name
            self?.freqLabel.text = freq
            self?.centsLabel.text = String(format: "%.1f cents", cents)
//            self?.needleView.update(cents: cents)
            self?.ballView.update(cents: cents)
            
            
            if cents < -5.7 {
                self?.statusLabel.text = "Too flat, tune up"
                self?.statusLabel.textColor = .systemOrange
            } else if cents > 5.7 {
                self?.statusLabel.text = "Too sharp, tune down"
                self?.statusLabel.textColor = .systemRed
            } else {
                self?.statusLabel.text = "Hold it right there!"
                self?.statusLabel.textColor = .systemGreen
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stop()
    }

    private func setupUI() {
        ballView.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        noteLabel.textAlignment = .center

        freqLabel.font = UIFont.systemFont(ofSize: 18)
        freqLabel.textAlignment = .center

        centsLabel.font = UIFont.systemFont(ofSize: 16)
        centsLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [ballView, noteLabel, freqLabel, centsLabel, statusLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ballView.widthAnchor.constraint(equalToConstant: 200),
            ballView.heightAnchor.constraint(equalToConstant: 150)
        ])
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.rightBarButtonItem = settingsButton
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
