//
//  CustomStackView.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 24.11.2023.
//

import UIKit

final class CustomStackView: UIStackView {
    init(axis: NSLayoutConstraint.Axis, spacing: CGFloat, arrangedSubviews: [UIView]) {
        super.init(frame: .zero)
        setupAxis(axis: axis)
        setupSpacing(spacing)
        setupSubviews(views: arrangedSubviews)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAxis(axis: NSLayoutConstraint.Axis) {
        self.axis = axis
    }
    
    private func setupSpacing(_ value: CGFloat) {
        self.spacing = value
    }
    
    private func setupSubviews(views: [UIView]) {
        views.forEach({ addArrangedSubview($0) })
    }
}
