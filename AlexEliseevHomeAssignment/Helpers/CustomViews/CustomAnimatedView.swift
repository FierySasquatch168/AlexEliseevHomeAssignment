//
//  CustomAnimatedView.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import UIKit

final class CustomAnimatedView: UIView {
    
    private var shapeLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var result: RequestResult? {
        didSet {
            guard let result else { return }
            createLayer(for: result)
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
    
    func toggleAnimationVisibility(for requestResult: RequestResult?) {
        guard let requestResult
        else {
            self.stopAnimation()
            self.isHidden = true
            return
        }
        self.stopAnimation()
        self.isHidden = false
        self.result = requestResult
        self.startAnimation()
    }
}

// MARK: - Ext UIView creation
private extension CustomAnimatedView {
    func createLayer(for result: RequestResult) {
        shapeLayer = createShapeLayer(from: result)
    }
    
    func removeTheLayer() {
        shapeLayer?.removeFromSuperlayer()
        shapeLayer = nil
    }
    
    func createShapeLayer(from result: RequestResult) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = createCGPath(for: result)
        layer.strokeColor = UIColor.green.cgColor
        layer.lineWidth = 5.0
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeEnd = 0.0 // Initially hide the circle
       
        return layer
    }
    
    func createCGPath(for result: RequestResult) -> CGPath {
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
        animation.repeatCount = .infinity
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
