//
//  DataStoreManager.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 04.09.2023.
//

import Foundation
import Combine

protocol DataStoreManagerProtocol {
    var saveItemPublisher: PassthroughSubject<[StarWarsCharacter], Never> { get set }
    var saveFavouritePublisher: PassthroughSubject<[String], Never> { get set }
    var storedDataPublisher: AnyPublisher<[StarWarsCharacter], Never> { get }
    var storedFavouritePublisher: AnyPublisher<[String], Never> { get }
    var currentStoredCharacters: [StarWarsCharacter] { get }
    var currentStoredFavouriteName: [String] { get }
}

final class DataStoreManager: DataStoreManagerProtocol {
    var saveItemPublisher = PassthroughSubject<[StarWarsCharacter], Never>()
    var saveFavouritePublisher = PassthroughSubject<[String], Never>()
    
    var storedDataPublisher: AnyPublisher<[StarWarsCharacter], Never> {
        return starWarsCharactersStore.dataPublisher.eraseToAnyPublisher()
    }
    
    var storedFavouritePublisher: AnyPublisher<[String], Never> {
        return favouriteCharacterStore.dataPublisher.eraseToAnyPublisher()
    }
    
    var currentStoredCharacters: [StarWarsCharacter] {
        return starWarsCharactersStore.getItems()
    }
    
    var currentStoredFavouriteName: [String] {
        return favouriteCharacterStore.getItems()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    let starWarsCharactersStore: GenericStorage<StarWarsCharacter>
    let favouriteCharacterStore: GenericStorage<String>
    
    // MARK: - Init
    init(starWarsCharactersStore: GenericStorage<StarWarsCharacter>,
         favouriteCharacterStore: GenericStorage<String>) {
        self.starWarsCharactersStore = starWarsCharactersStore
        self.favouriteCharacterStore = favouriteCharacterStore
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        saveItemPublisher
            .sink { [weak self] modelsToStore in
                self?.storeItems(modelsToStore)
            }
            .store(in: &cancellables)
        
        saveFavouritePublisher
            .sink { [weak self] favourite in
                self?.storeFavourite(favourite)
        }
            .store(in: &cancellables)
    }
}

// MARK: - Ext store
private extension DataStoreManager {
    func storeItems(_ model: [StarWarsCharacter]) {
        model.forEach({ starWarsCharactersStore.addItem($0) })
    }
    
    func storeFavourite(_ items: [String]) {
        favouriteCharacterStore.deleteItem(nil)
        items.forEach({ favouriteCharacterStore.addItem($0) })
    }
}
