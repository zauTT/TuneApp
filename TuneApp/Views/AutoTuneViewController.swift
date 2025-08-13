//
//  AutoTuneViewController.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 12.08.25.
//


import UIKit

final class AutoTuneViewController: UIViewController {
    private let noteLabel = UILabel()
    private let freqLabel = UILabel()
    private let centsLabel = UILabel()
    private let viewModel = TunerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Auto Tune"

        setupUI()

        viewModel.onUpdate = { [weak self] name, freq, cents in
            self?.noteLabel.text = name
            self?.freqLabel.text = freq
            self?.centsLabel.text = String(format: "%.1f cents", cents)
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
        noteLabel.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        noteLabel.textAlignment = .center

        freqLabel.font = UIFont.systemFont(ofSize: 18)
        freqLabel.textAlignment = .center

        centsLabel.font = UIFont.systemFont(ofSize: 16)
        centsLabel.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [noteLabel, freqLabel, centsLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
