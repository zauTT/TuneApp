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
    private var tickLayers: [CAShapeLayer] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.addSublayer(dialLayer)
        setupNeedle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNeedle() {
        needle.frame = CGRect(x: bounds.midX - 1, y: bounds.midY - 50, width: 2, height: 100)
        needle.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        addSubview(needle)
    }

    private func updateNeedle(to angle: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.needle.transform = CGAffineTransform(rotationAngle: angle)
        }
        
        let color: UIColor
        let normalizedAngle = (angle + .pi / 4) / (.pi / 2)
        if normalizedAngle < 0.5 {
            let t = normalizedAngle * 2
            color = interpolate(from: .systemBlue, to: .systemGreen, alpha: t)
        } else {
            let t = (normalizedAngle - 0.5) * 2
            color = interpolate(from: .systemGreen, to: .systemRed, alpha: t)
        }
        
        UIView.transition(with: needle, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.needle.backgroundColor = color
        }, completion: nil)
    }
    
    private func interpolate(from color1: UIColor, to color2: UIColor, alpha t: CGFloat) -> UIColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(
            red: r1 + (r2 - r1) * t,
            green: g1 + (g2 - g1) * t,
            blue: b1 + (b2 - b1) * t,
            alpha: a1 + (a2 - a1) * t
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        needle.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        if dialLayer.path == nil {
            updateDialPath()
        }
    }
    
    private func updateDialPath() {
        let needleLength = needle.frame.height
        let radius = needleLength
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let startAngle = CGFloat.pi
        let endAngle = CGFloat(0)
        
        let arcPath = UIBezierPath(arcCenter: center,
                                   radius: radius,
                                   startAngle: startAngle,
                                   endAngle: endAngle,
                                   clockwise: true)
        dialLayer.path = arcPath.cgPath
        dialLayer.strokeColor = UIColor.systemGray4.cgColor
        dialLayer.lineWidth = 4
        dialLayer.fillColor = UIColor.clear.cgColor
        
        tickLayers.forEach { $0.removeFromSuperlayer() }
        tickLayers.removeAll()
        
        let tickCount = 11
        let tickLength: CGFloat = 10
        let arcRadius = radius
        
        for i in 0..<tickCount {
            let tickAngle = startAngle + (endAngle + startAngle) * CGFloat(i) / CGFloat(tickCount - 1)
            
            let outerPoint = CGPoint(
                x: center.x + arcRadius * cos(tickAngle),
                y: center.y + arcRadius * sin(tickAngle)
            )
            
            let innerPoint = CGPoint(
                x: center.x + (arcRadius - tickLength) * cos(tickAngle),
                y: center.y + (arcRadius - tickLength) * sin(tickAngle)
            )
            
            let tickPath = UIBezierPath()
            tickPath.move(to: innerPoint)
            tickPath.addLine(to: outerPoint)
            
            let tickLayer = CAShapeLayer()
            tickLayer.path = tickPath.cgPath
            tickLayer.strokeColor = UIColor.label.cgColor
            tickLayer.lineWidth = 2
            
            layer.addSublayer(tickLayer)
            tickLayers.append(tickLayer)
        }
    }
    
    func update(cents: Double) {
        let clamped = max(-50, min(50, cents))
        let angle = CGFloat(clamped / 50) * (.pi / 4)
        updateNeedle(to: angle)
    }
}
