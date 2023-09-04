//
//  TableViewDiffableDataSource.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import UIKit

protocol TableDataSourceProtocol {
    func createDataSource(for tableView: UITableView, with data: [VisibleCharacterModel])
    func updateTableView(with data: [VisibleCharacterModel], animatingDifference: Bool)
}

// MARK: Final class
final class TableViewDataSource {
    typealias DataSource = UITableViewDiffableDataSource<Int, VisibleCharacterModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, VisibleCharacterModel>
    
    private var dataSource: DataSource?
}

extension TableViewDataSource: TableDataSourceProtocol {
    func createDataSource(for tableView: UITableView, with data: [VisibleCharacterModel]) {
        dataSource = DataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            return self?.characterCell(tableView: tableView, indexPath: indexPath, item: itemIdentifier)
        })
        
        dataSource?.defaultRowAnimation = .fade
        
        updateTableView(with: data, animatingDifference: true)
    }
    
    func updateTableView(with data: [VisibleCharacterModel], animatingDifference: Bool) {
        dataSource?.apply(createSnapshot(from: data), animatingDifferences: animatingDifference)
    }
}

// MARK: - Ext Cell creation
private extension TableViewDataSource {
    func characterCell(tableView: UITableView, indexPath: IndexPath, item: VisibleCharacterModel) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? MainTableViewCell
        else { return MainTableViewCell() }
        cell.viewModel = MainCellViewModel(character: item)
        cell.selectionStyle = .none
        cell.isSelected = item.favourite
        
        print("cellName: \(item.name) isFavourite: \(item.favourite) and isSelected: \(cell.isSelected)")
        return cell
    }
    
    // MARK: Snapshot
    func createSnapshot(from data: [VisibleCharacterModel]) -> Snapshot {
        var snapshot = Snapshot()
        let section = 0
        snapshot.appendSections([section])
        snapshot.appendItems(data, toSection: section)
        return snapshot
    }
}
