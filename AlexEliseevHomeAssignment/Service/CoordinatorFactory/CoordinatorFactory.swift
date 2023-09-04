//
//  CoordinatorFactory.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

protocol CoordinatorFactoryProtocol {
    func createFlowCoordinator(with router: Routable) -> CoordinatorProtocol
}

final class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    private let screenFactory: ScreenFactoryProtocol = ScreenFactory()
    private let networkService: NetworkService = BasicNetworkService()
    private let dataSourceManager: TableDataSourceProtocol = TableViewDataSource()
    
    func createFlowCoordinator(with router: Routable) -> CoordinatorProtocol {
        return FlowCoordinator(router: router,
                               screenFactory: screenFactory,
                               networkService: networkService,
                               dataSource: dataSourceManager)
    }
}
