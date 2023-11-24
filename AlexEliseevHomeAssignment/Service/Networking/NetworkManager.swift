//
//  NetworkManager.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 24.11.2023.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func createGetRequestPublisher<T: Decodable>(_ inputName: String, query: QueryItems, type: T.Type) -> AnyPublisher<T, NetworkError>
}

final class NetworkManager {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension NetworkManager: NetworkManagerProtocol {
    func createGetRequestPublisher<T>(_ inputName: String, 
                                      query: QueryItems,
                                      type: T.Type) -> AnyPublisher<T, NetworkError> where T : Decodable {
        let request = RequestCreator.createGetRequest(endPoint: .main, query: query, item: inputName)
        return networkService.networkPublisher(request: request, type: type).eraseToAnyPublisher()
    }
}
