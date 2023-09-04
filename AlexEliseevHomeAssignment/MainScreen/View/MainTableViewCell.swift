//
//  MainTableViewCell.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import UIKit
import Combine

final class MainTableViewCell: UITableViewCell {
    private var cancellables = Set<AnyCancellable>()

    var viewModel: MainCellViewModel? {
        didSet {
            bind()
        }
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    private lazy var heightButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.black, for: .normal)
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(heightButton)
        
        return stackView
    }()
    
    override var isSelected: Bool {
        didSet {
            mainStackView.backgroundColor = isSelected ? .yellow : .clear
        }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Ext Bind
private extension MainTableViewCell {
    func bind() {
        viewModel?.$character
            .sink(receiveValue: { [weak self] character in
                self?.updateCell(character)
            }).store(in: &cancellables)
    }
    
    func updateCell(_ model: VisibleCharacterModel) {
        nameLabel.text = model.name
        heightButton.setTitle(model.height, for: .normal)
    }
}


// MARK: - Ext Constraints
private extension MainTableViewCell {
    func setupConstraints() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
