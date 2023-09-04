//
//  CustomAnimatedView.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import UIKit

final class CustomAnimatedView: UIView {
    
    private var shapeLayer: CAShapeLayer?
    
    var result: RequestResult? {
        didSet {
            if result != nil { createLayer() }
        }
    }
    
    func startAnimation() {
        guard let shapeLayer = shapeLayer, let result else { return }
        layer.addSublayer(shapeLayer)
        createAnimationLayer(for: shapeLayer, with: result)
    }
    
    func stopAnimation() {
        removeTheLayer()
    }
}

// MARK: - Ext UIView creation
private extension CustomAnimatedView {
    func createLayer() {
        shapeLayer = createShapeLayer()
    }
    
    func removeTheLayer() {
        shapeLayer?.removeFromSuperlayer()
        shapeLayer = nil
    }
    
    func createShapeLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = createCGPath()
        layer.strokeColor = UIColor.systemTeal.cgColor
        layer.lineWidth = 5.0
        layer.fillColor = UIColor.clear.cgColor
        
        if result == .loading { layer.strokeEnd = 0.0  }
        
        return layer
    }
    
    func createCGPath() -> CGPath {
        let size = createSize()
        return createCirclePath(with: size)
    }
}

// MARK: - Ext Animation layer
private extension CustomAnimatedView {
    func createAnimationLayer(for layer: CAShapeLayer, with result: RequestResult) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.9
        
        if result == .loading { animation.repeatCount = .infinity }
        
        layer.add(animation, forKey: "strokeAnimation")
        
    }
}

// MARK: - Ext CGPAths
private extension CustomAnimatedView {
    func createSize() -> CGSize {
        CGSize(width: bounds.width, height: bounds.height)
    }
    
    func createCirclePath(with size: CGSize) -> CGPath {
        return UIBezierPath(ovalIn: bounds).cgPath
    }
}
