//
//  CustomSearchTextField.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 24.11.2023.
//

import UIKit

final class CustomSearchTextField: UISearchTextField {
    init(delegate: UITextFieldDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        placeholder = K.Placeholders.searchPlaceholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
