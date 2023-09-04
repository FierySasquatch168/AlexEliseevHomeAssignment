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
    private let networkService: NetworkService
    private let dataSource: TableDataSourceProtocol
    
    init(router: Routable,
         screenFactory: ScreenFactoryProtocol,
         networkService: NetworkService,
         dataSource: TableDataSourceProtocol) {
        self.router = router
        self.screenFactory = screenFactory
        self.networkService = networkService
        self.dataSource = dataSource
    }
    
    func start() {
        showMainScreen()
    }
}

private extension FlowCoordinator {
    func showMainScreen() {
        let screen = screenFactory.createMainScreen(networkService: networkService, dataSource: dataSource)
        
        router.setupRootViewController(viewController: screen)
    }
}
