//
//  BallView.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 08.09.25.
//

import UIKit

final class BallView: UIView {
    
    private let ballView = UIView()
    private let centerBall = UIView()
    
    private let minCents: CGFloat = -50
    private let maxCents: CGFloat = 50
    
    private var ballCenterXConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerBall.backgroundColor = UIColor.systemGray5
        centerBall.layer.cornerRadius = 90
        centerBall.translatesAutoresizingMaskIntoConstraints = false
        addSubview(centerBall)
        
        NSLayoutConstraint.activate([
            centerBall.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerBall.centerYAnchor.constraint(equalTo: centerYAnchor),
            centerBall.widthAnchor.constraint(equalToConstant: 180),
            centerBall.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        ballView.backgroundColor = .systemBlue
        ballView.layer.cornerRadius = 85
        ballView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ballView)
        
        NSLayoutConstraint.activate([
            ballView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ballView.widthAnchor.constraint(equalToConstant: 170),
            ballView.heightAnchor.constraint(equalToConstant: 170)
        ])
        
        ballCenterXConstraint = ballView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ballCenterXConstraint?.isActive = true
    }
    
    //MARK: - Update ball position and color based on cents
    
    func update(cents: Double) {
        let clamped = max(minCents, min(maxCents, CGFloat(cents)))
        let ratio = (clamped - minCents) / (maxCents - minCents)
        let trackWidth = bounds.width - 80
        
        let offset = (ratio * trackWidth) - (trackWidth / 2)
        ballCenterXConstraint?.constant = offset
        
        if cents < -5.7 {
            ballView.backgroundColor = .systemOrange
        } else if cents > 5.7 {
            ballView.backgroundColor = .systemRed
        } else {
            ballView.backgroundColor = .systemGreen
        }
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
