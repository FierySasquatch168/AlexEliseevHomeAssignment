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
    
    private lazy var screenFactory: ScreenFactoryProtocol = ScreenFactory()
    private lazy var networkService: NetworkService = BasicNetworkService()
    private lazy var networkMaanger: NetworkManagerProtocol = NetworkManager(networkService: networkService)
    private lazy var dataSourceManager: TableDataSourceProtocol = TableViewDataSource()
    private lazy var dataStore: DataStoreManagerProtocol = DataStoreManager(
        starWarsCharactersStore: GenericStorage<StarWarsCharacter>(),
        favouriteCharacterStore: GenericStorage<String>()
    )
    
    func createFlowCoordinator(with router: Routable) -> CoordinatorProtocol {
        return FlowCoordinator(router: router,
                               screenFactory: screenFactory,
                               networkManager: networkMaanger,
                               dataSource: dataSourceManager,
                               dataStore: dataStore)
    }
}
