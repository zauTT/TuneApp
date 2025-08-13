//
//  SettingsViewController.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 12.08.25.
//


import UIKit

final class SettingsViewController: UIViewController {
    private let instruments = [("Guitar", true), ("Ukulele", false), ("Bass", false)]
    private let tunings = [("Standard", true), ("Drop D", false), ("Open G", false)]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        let header = UILabel()
        header.text = "Settings"
        header.font = .systemFont(ofSize: 22, weight: .semibold)
        header.textAlignment = .center
        
        let instrumentStack = UIStackView()
        instrumentStack.axis = .horizontal
        instrumentStack.spacing = 12
        instrumentStack.alignment = .center

        for item in instruments {
            let btn = UIButton(type: .system)
            btn.setTitle(item.0, for: .normal)
            btn.layer.cornerRadius = 10
            btn.backgroundColor = item.1 ? .systemBlue : .secondarySystemBackground
            btn.tintColor = item.1 ? .white : .label
            btn.widthAnchor.constraint(equalToConstant: 120).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
            btn.addTarget(self, action: #selector(instrumentTapped(_:)), for: .touchUpInside)
            instrumentStack.addArrangedSubview(btn)
        }

        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(instrumentStack)
        instrumentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(header)
        view.addSubview(scroll)
        
        let tuningsStack = UIStackView()
        tuningsStack.axis = .vertical
        tuningsStack.spacing = 12
        for t in tunings {
            let btn = UIButton(type: .system)
            btn.setTitle(t.0, for: .normal)
            btn.layer.cornerRadius = 10
            btn.backgroundColor = t.1 ? .systemBlue : .secondarySystemBackground
            btn.tintColor = t.1 ? .white : .label
            btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
            btn.addTarget(self, action: #selector(tuningTapped(_:)), for: .touchUpInside)
            tuningsStack.addArrangedSubview(btn)
        }

        let container = UIStackView(arrangedSubviews: [header, scroll, tuningsStack])
        container.axis = .vertical
        container.spacing = 20
        container.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            instrumentStack.topAnchor.constraint(equalTo: scroll.topAnchor),
            instrumentStack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            instrumentStack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            instrumentStack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            instrumentStack.heightAnchor.constraint(equalTo: scroll.heightAnchor)
        ])
        scroll.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    @objc private func instrumentTapped(_ sender: UIButton) {
        if sender.backgroundColor == .systemBlue {
            return
        }
        let alert = UIAlertController(title: "Coming soon", message: "More instruments will be available in a future update.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func tuningTapped(_ sender: UIButton) {
        if sender.backgroundColor == .systemBlue { return }
        let alert = UIAlertController(title: "Coming soon", message: "More tunings will be available in a future update.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
