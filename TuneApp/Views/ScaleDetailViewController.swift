//
//  ScaleDetailViewController.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 02.09.25.
//

import UIKit

final class ScaleDetailViewController: UIViewController {
    private let scale: Scale
    private let scaleLabel = UILabel()
    private let imageView = UIImageView()
    
    init(scale: Scale) {
        self.scale = scale
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        scaleLabel.text = scale.name
        scaleLabel.textColor = .label
        scaleLabel.font = .systemFont(ofSize: 20, weight: .medium)
        scaleLabel.textAlignment = .center
        scaleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.image = UIImage(named: scale.imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scaleLabel)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            scaleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            scaleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scaleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}
