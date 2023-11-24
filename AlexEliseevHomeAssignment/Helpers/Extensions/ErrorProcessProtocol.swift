//
//  ErrorProcessProtocol.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 24.11.2023.
//

import Foundation
import Combine

protocol ErrorProcessProtocol {
    var errorPublisher: PassthroughSubject<NetworkError, Never> { get }
    var requestResultPublisher: CurrentValueSubject<RequestResult?, Never> { get }
    func processCompletion(_ completion: Subscribers.Completion<NetworkError>)
    func updateRequestResult(result: RequestResult?)
}

extension ErrorProcessProtocol {
    func processCompletion(_ completion: Subscribers.Completion<NetworkError>) {
        if case .failure(let error) = completion {
            errorPublisher.send(error)
        }
    }
    
    func updateRequestResult(result: RequestResult?) {
        requestResultPublisher.send(result)
    }
}
