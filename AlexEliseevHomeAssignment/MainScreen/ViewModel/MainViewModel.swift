//
//  MainViewModel.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation
import Combine

protocol MainViewModelProtocol {
    var visibleObjectsPublisher: CurrentValueSubject<[VisibleCharacterModel], Never> { get }
    var requestResultPublisher: CurrentValueSubject<RequestResult?, NetworkError> { get }
    var nameSearchPublisher: PassthroughSubject<String, Never> { get set }
    var lastRowPublisher: PassthroughSubject<Int?, Never> { get set }
    var clearTextFieldPublisher: PassthroughSubject<Bool, Never> { get set }
    
    var favouriteItemPublisher: CurrentValueSubject<IndexPath?, Never> { get set }
}

final class MainViewModel: MainViewModelProtocol {
    var visibleObjectsPublisher = CurrentValueSubject<[VisibleCharacterModel], Never>([])
    var requestResultPublisher = CurrentValueSubject<RequestResult?, NetworkError>(nil)
    var nameSearchPublisher = PassthroughSubject<String, Never>()
    var lastRowPublisher = PassthroughSubject<Int?, Never>()
    var clearTextFieldPublisher = PassthroughSubject<Bool, Never>()
    
    var favouriteItemPublisher = CurrentValueSubject<IndexPath?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    private var totalCharacters: Int = 0
    private var currentPage: Int = 1
    
    private var favouriteCharacter: [String] {
        return dataStore.currentStoredFavouriteName
    }
    
    private var storedCharacters: [StarWarsCharacter] {
        return dataStore.currentStoredCharacters
    }
    
    private var visibleRows: [VisibleCharacterModel] = [] {
        didSet {
            sendUpdates(visibleRows)
        }
    }
    
    private let networkService: NetworkService
    private let dataStore: DataStoreManagerProtocol
    
    // MARK: - init
    init(networkService: NetworkService, dataStore: DataStoreManagerProtocol) {
        self.networkService = networkService
        self.dataStore = dataStore
        sendPageRequest()
        bindView()
        bindStore()
    }
    
    // MARK: - Bind
    private func bindView() {
        lastRowPublisher
            .sink { [weak self] lastRow in
                self?.requestNextPageIfTheLastRow(lastRow)
            }
            .store(in: &cancellables)
        
        nameSearchPublisher
            .sink { [weak self] searchName in
                self?.sendNameRequest(searchName)
        }
            .store(in: &cancellables)
        
        clearTextFieldPublisher
            .sink { [weak self] isCleared in
                guard let self else { return }
                self.updateVisibleRows(self.storedCharacters)
        }
            .store(in: &cancellables)
        
        favouriteItemPublisher
            .sink { [weak self] selectedIndexPath in
                self?.selectCharacter(selectedIndexPath?.row)
        }
            .store(in: &cancellables)
    }
    
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
                print("updated")
        }
            .store(in: &cancellables)
    }
    
    private func sendUpdates(_ model: [VisibleCharacterModel]) {
        if model.count == totalCharacters {
            visibleObjectsPublisher.send(model.sorted(by: { $0.height.toCGFloat() ?? 0 > $1.height.toCGFloat() ?? 0 }))
        } else {
            visibleObjectsPublisher.send(model)
        }
    }
    
    private func selectCharacter(_ row: Int?) {
        guard let row else { return }
        dataStore.saveFavouritePublisher.send([storedCharacters[row].name])
    }
}

// MARK: - Ext Pagination
private extension MainViewModel {
    func requestNextPageIfTheLastRow(_ row: Int?) {
        guard let row else { return }
        if row == visibleRows.count - 1 && totalCharacters != visibleRows.count {
            currentPage += 1
            sendPageRequest()
        }
    }
}

// MARK: - Ext Request
private extension MainViewModel {
    func sendPageRequest() {
        if requestResultPublisher.value != nil { return }
        requestResultPublisher.send(.loading)
        let request = RequestCreator.createGetRequest(endPoint: EndPointValue.main, query: QueryItems.main, item: currentPage)
        
        networkService.networkPublisher(request: request, type: ResponseModel.self)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print(error)
                }
                self?.requestResultPublisher.send(nil)
            }, receiveValue: { [weak self] responseModel in
                self?.totalCharacters = responseModel.count
                self?.dataStore.saveItemPublisher.send(responseModel.results)
            })
            .store(in: &cancellables)
    }
    
    func sendNameRequest(_ name: String) {
        if requestResultPublisher.value != nil { return }
        requestResultPublisher.send(.loading)
        let request = RequestCreator.createSearchRequest(endPoint: EndPointValue.main, query: QueryItems.characterName, name: name)
        networkService.networkPublisher(request: request, type: ResponseModel.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print(error)
                }
                self?.requestResultPublisher.send(nil)
            } receiveValue: { [weak self] response in
                self?.updateVisibleRows(response.results)
            }
            .store(in: &cancellables)

    }
}

// MARK: - Ext Favourites
private extension MainViewModel {
    func updateVisibleRows(_ receivedModel: [StarWarsCharacter]) {
        visibleRows = receivedModel.map { character in
            let isFavourite = favouriteCharacter.contains(character.name)
            return VisibleCharacterModel(id: character.id, name: character.name,
                                         height: character.height,
                                         favourite: isFavourite)
        }
    }
}

