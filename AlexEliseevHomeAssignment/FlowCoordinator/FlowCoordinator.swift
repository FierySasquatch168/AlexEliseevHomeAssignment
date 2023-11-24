//
//  FlowCoordinator.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

protocol CoordinatorProtocol: AnyObject {
    func start()
}

final class FlowCoordinator: CoordinatorProtocol {
    
    private let router: Routable
    private let screenFactory: ScreenFactoryProtocol
    private let networkManager: NetworkManagerProtocol
    private let dataSource: TableDataSourceProtocol
    private let dataStore: DataStoreManagerProtocol
    
    init(router: Routable,
         screenFactory: ScreenFactoryProtocol,
         networkManager: NetworkManagerProtocol,
         dataSource: TableDataSourceProtocol,
         dataStore: DataStoreManagerProtocol) {
        self.router = router
        self.screenFactory = screenFactory
        self.networkManager = networkManager
        self.dataSource = dataSource
        self.dataStore = dataStore
    }
    
    func start() {
        showMainScreen()
    }
}

private extension FlowCoordinator {
    func showMainScreen() {
        let screen = screenFactory.createMainScreen(networkService: networkManager,
                                                    dataSource: dataSource,
                                                    dataStore: dataStore)
        
        router.setupRootViewController(viewController: screen)
    }
}
