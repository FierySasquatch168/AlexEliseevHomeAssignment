//
//  MainViewModel.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation
import Combine

final class MainViewModel: ViewModelCombineProtocol {
    var errorPublisher = PassthroughSubject<NetworkError, Never>()
    var requestResultPublisher = CurrentValueSubject<RequestResult?, Never>(nil)
    var visibleObjectsPublisher = CurrentValueSubject<[VisibleCharacterModel], Never>([])
        
    private var cancellables = Set<AnyCancellable>()
    
    private var totalCharacters: Int = 0
    private var currentPage: Int = 1
    private var currentFavouriteIndexPath: IndexPath?
    
    private var storedCharacters: [StarWarsCharacter] {
        return dataStore.currentStoredCharacters
    }
    
    private var visibleRows: [VisibleCharacterModel] = [] {
        didSet {
            sendUpdates(visibleRows)
        }
    }
    
    private let networkService: NetworkManagerProtocol
    private let dataStore: DataStoreManagerProtocol
    
    // MARK: - init
    init(networkService: NetworkManagerProtocol, dataStore: DataStoreManagerProtocol) {
        self.networkService = networkService
        self.dataStore = dataStore
        sendRequest(currentPage.toString(), isPageRequest: true)
        bindStore()
    }
    
    // MARK: - Bind
    private func bindStore() {
        dataStore.storedDataPublisher
            .sink { [weak self] storedModel in
                self?.updateVisibleRows(storedModel)
        }
            .store(in: &cancellables)
        
        dataStore.storedFavouritePublisher
            .sink { [weak self] favourites in
                guard let self else { return }
                self.updateVisibleRows(self.storedCharacters)
        }
            .store(in: &cancellables)
    }
    
    private func sendUpdates(_ model: [VisibleCharacterModel]) {
        if model.count == totalCharacters {
            visibleObjectsPublisher.send(model.sorted(by: { $0.getFloatHeight() > $1.getFloatHeight() }))
        } else {
            visibleObjectsPublisher.send(model)
        }
    }
}

// MARK: - Ext ScrollPaginationProtocol
extension MainViewModel: ScrollPaginationProtocol {
    func didScrollForNextPage(row: Int?) {
        guard let row else { return }
        if isCorrectRowForPagination(row) {
            currentPage += 1
            sendRequest(currentPage.toString(), isPageRequest: true)
        }
    }
    
    private func isCorrectRowForPagination(_ row: Int) -> Bool {
        return row == visibleRows.count - 1 && totalCharacters != visibleRows.count
    }
}

// MARK: - Ext FavouriteSelectable
extension MainViewModel: FavouriteSelectable {
    func selectFavourite(at indexPath: IndexPath?) {
        guard let row = indexPath?.row else { return }
        dataStore.saveFavouritePublisher.send([storedCharacters[row].name])
        currentFavouriteIndexPath = indexPath
    }
    
    func currentFavourite() -> IndexPath? {
        return currentFavouriteIndexPath
    }
}

// MARK: - Ext SearchableViewModelProtocol
extension MainViewModel: SearchableViewModelProtocol {
    func searchFor(_ text: String) {
        text.isEmpty ? updateVisibleRows(storedCharacters) : sendRequest(text, isPageRequest: false)
    }
}

// MARK: - Ext Request
private extension MainViewModel {
    func sendRequest(_ name: String, isPageRequest: Bool) {
        requestResultPublisher.send(.loading)
        networkService.createGetRequestPublisher(name, query: .main, type: ResponseModel.self)
            .sink { [weak self] completion in
                self?.processCompletion(completion)
                self?.updateRequestResult(result: nil)
            } receiveValue: { [weak self] model in
                self?.processModel(model, isPageRequest: isPageRequest)
            }.store(in: &cancellables)

    }
    
    func processModel(_ model: ResponseModel, isPageRequest: Bool) {
        isPageRequest ? updateDataBase(model) : updateVisibleRows(model.results)
    }
    
    func updateDataBase(_ model: ResponseModel) {
        totalCharacters = model.count
        dataStore.saveItemPublisher.send(model.results)
    }
}

// MARK: - Ext Favourites
private extension MainViewModel {
    func updateVisibleRows(_ receivedModel: [StarWarsCharacter]) {
        visibleRows = getVisibleCharacters(receivedModel)
    }
    
    func getVisibleCharacters(_ receivedModel: [StarWarsCharacter]) -> [VisibleCharacterModel] {
        receivedModel.map({ VisibleCharacterModel(character: $0, isFavourite: favouriteContaintsItem($0)) })
    }
    
    func favouriteContaintsItem(_ character: StarWarsCharacter) -> Bool {
        dataStore.currentStoredFavouriteName.contains(character.name)
    }
}
