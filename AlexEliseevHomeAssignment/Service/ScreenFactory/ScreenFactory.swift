//
//  ScreenFactory.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

protocol ScreenFactoryProtocol {
    func createMainScreen(networkService: NetworkService,
                          dataSource: TableDataSourceProtocol,
                          dataStore: DataStoreManagerProtocol) -> Presentable
}

struct ScreenFactory: ScreenFactoryProtocol {
    func createMainScreen(networkService: NetworkService,
                          dataSource: TableDataSourceProtocol,
                          dataStore: DataStoreManagerProtocol) -> Presentable {
        let viewModel = MainViewModel(networkService: networkService, dataStore: dataStore)
        return MainViewController(viewModel: viewModel, dataSource: dataSource)
    }
}
