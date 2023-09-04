//
//  ScreenFactory.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

protocol ScreenFactoryProtocol {
    func createMainScreen(networkService: NetworkService, dataSource: TableDataSourceProtocol) -> Presentable
}

struct ScreenFactory: ScreenFactoryProtocol {
    func createMainScreen(networkService: NetworkService, dataSource: TableDataSourceProtocol) -> Presentable {
        let viewModel = MainViewModel(networkService: networkService)
        return MainViewController(viewModel: viewModel, dataSource: dataSource)
    }
}
