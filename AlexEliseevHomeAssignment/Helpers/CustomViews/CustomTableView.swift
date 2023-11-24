//
//  CustomTableView.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 24.11.2023.
//

import UIKit

final class CustomTableView: UITableView {
    init(delegate: UITableViewDelegate) {
        super.init(frame: .zero, style: .plain)
        self.delegate = delegate
        allowsMultipleSelection = false
        register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
