//
//  NeedleView.swift
//  TuneApp
//
//  Created by Giorgi Zautashvili on 14.08.25.
//


import UIKit

final class NeedleView: UIView {
    private let needle = UIView()
    private let dialLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupDial()
        setupNeedle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupDial() {
        layer.addSublayer(dialLayer)
    }

    private func setupNeedle() {
        needle.backgroundColor = .systemRed
        needle.frame = CGRect(x: bounds.midX - 1, y: bounds.midY - 50, width: 2, height: 100)
        needle.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        addSubview(needle)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        needle.center = CGPoint(x: bounds.midX, y: bounds.midY)
        updateDialPath()
    }

    private func updateDialPath() {
        let radius = min(bounds.width, bounds.height) / 2 - 20
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let startAngle = CGFloat.pi * 5 / 4
        let endAngle = CGFloat.pi * -1 / 4

        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        dialLayer.path = path.cgPath
        dialLayer.strokeColor = UIColor.systemGray4.cgColor
        dialLayer.lineWidth = 8
        dialLayer.fillColor = UIColor.clear.cgColor
    }

    func update(cents: Double) {
        let clamped = max(-50, min(50, cents))
        let angle = CGFloat(clamped / 50) * (.pi / 4)
        UIView.animate(withDuration: 0.1) {
            self.needle.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
}
