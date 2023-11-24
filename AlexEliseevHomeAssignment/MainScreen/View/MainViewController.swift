//
//  MainViewController.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import UIKit
import Combine

final class MainViewController: UIViewController, LoadingViewControllerProtocol {
    private let viewModel: ViewModelCombineProtocol
    private let dataSource: TableDataSourceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchTextField = CustomSearchTextField(delegate: self)
    private lazy var tableView = CustomTableView(delegate: self)
    private lazy var mainStackView = CustomStackView(axis: .vertical,
                                                     spacing: 20,
                                                     arrangedSubviews: [searchTextField, tableView])
    
    lazy var loadingView = CustomAnimatedView(frame: .zero)
    
    // MARK: - Init
    init(viewModel: ViewModelCombineProtocol,
         dataSource: TableDataSourceProtocol) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        createTableView()
        bind()
    }
    
    private func createTableView() {
        dataSource.createDataSource(for: tableView,
                                    with: viewModel.visibleObjectsPublisher.value)
    }
}

// MARK: - Ext Bind
private extension MainViewController {
    func bind() {
        viewModel.visibleObjectsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] characters in
                self?.dataSource.updateTableView(with: characters, animatingDifference: true)
            }
            .store(in: &cancellables)
        
        viewModel.requestResultPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requestResult in
                self?.loadingView.toggleAnimationVisibility(for: requestResult)
            }.store(in: &cancellables)
    }
}

// MARK: - Ext TableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let stringHeight = viewModel.visibleObjectsPublisher.value[indexPath.row].height
        return stringHeight.toCGFloat()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else { return }
        let lastVisibleRow = tableView.indexPathsForVisibleRows?.last?.row
        viewModel.didScrollForNextPage(row: lastVisibleRow)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MainTableViewCell else { return }
        cell.isSelected = true
        viewModel.selectFavourite(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let selectedIndexPath = viewModel.currentFavourite(),
              let cell = tableView.cellForRow(at: selectedIndexPath) as? MainTableViewCell
        else { return }
        cell.isSelected = false
    }
}

// MARK: - Ext TextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text { viewModel.searchFor(text) }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.searchFor("")
        return true
    }
}

// MARK: - Ext Constraints
private extension MainViewController {
    func setupConstraints() {
        setupTableView()
        setupLoadingView()
    }
    
    func setupTableView() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

