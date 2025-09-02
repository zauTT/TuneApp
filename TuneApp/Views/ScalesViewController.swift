//
//  SScalesViewController.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 02.09.25.
//

import UIKit

struct Scale {
    let name: String
    let imageName: String
}

final class ScalesViewController: UIViewController {
    
    private let essentialLabel: UILabel = {
        let label = UILabel()
        label.text = "5 Essential Scales for Beginners"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var scales: [Scale] = [
        Scale(name: "C Major Scale", imageName: "cMajorScale"),
        Scale(name: "E Minor Pentatonic", imageName: "eMinorPent"),
        Scale(name: "A Minor Pentatonic", imageName: "aMinorPent"),
        Scale(name: "E Minor Harmonic", imageName: "eMinorHarmonic"),
        Scale(name: "G Major Scale", imageName: "gMajorScale")
    ]
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scales"
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(essentialLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ScaleCell.self, forCellWithReuseIdentifier: "ScaleCell")
        
        self.collectionView = collectionView
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            essentialLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            essentialLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            essentialLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: essentialLabel.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ScalesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scales.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScaleCell", for: indexPath) as? ScaleCell else {
            return UICollectionViewCell()
        }
        let scale = scales[indexPath.item]
        cell.configure(with: scale)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let scale = scales[indexPath.item]
        let detailVC = ScaleDetailViewController(scale: scale)
        detailVC.modalPresentationStyle = .pageSheet
        present(detailVC, animated: true)
    }
}
