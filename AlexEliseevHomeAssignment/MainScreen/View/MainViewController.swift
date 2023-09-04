//
//  MainViewController.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import UIKit
import Combine

final class MainViewController: UIViewController {    
    private let viewModel: MainViewModelProtocol
    private let dataSource: TableDataSourceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.placeholder = K.Placeholders.searchPlaceholder
        textField.delegate = self
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.allowsMultipleSelection = false
        table.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        return table
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(tableView)
        return stackView
    }()
    
    private lazy var loadingView: CustomAnimatedView = {
        let view = CustomAnimatedView(frame: .zero)
        return view
    }()
    
    // MARK: - Init
    init(viewModel: MainViewModelProtocol,
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
                self?.dataSource.updateTableView(with: characters, animatingDifference: false)
                self?.select()
            }
            .store(in: &cancellables)
        
        viewModel.requestResultPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] requestResult in
                self?.updateLoadingAnimation(requestResult)
            }
            .store(in: &cancellables)
    }
    
    func updateLoadingAnimation(_ result: RequestResult?) {
        showOrHideAnimation(loadingView, for: result)
    }
    
    func select() {
        tableView.selectRow(at: viewModel.favouriteItemPublisher.value,
                            animated: false,
                            scrollPosition: .none)
    }
}

// MARK: - Ext TableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let stringHeight = viewModel.visibleObjectsPublisher.value[indexPath.row].height
        return stringHeight.toCGFloat() ?? 50
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else { return }

        let lastVisibleRow = tableView.indexPathsForVisibleRows?.last?.row
        viewModel.lastRowPublisher.send(lastVisibleRow)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MainTableViewCell else { return }
        cell.isSelected = true
        viewModel.favouriteItemPublisher.send(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let selectedIndexPath = viewModel.favouriteItemPublisher.value,
              let cell = tableView.cellForRow(at: selectedIndexPath) as? MainTableViewCell
        else { return }
        cell.isSelected = false
    }
}

// MARK: - Ext TextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            viewModel.nameSearchPublisher.send(text)
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.clearTextFieldPublisher.send(true)
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
    
    func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 50),
            loadingView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}

