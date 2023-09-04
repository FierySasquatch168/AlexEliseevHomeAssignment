//
//  NetworkService.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation
import Combine

protocol NetworkService {
    func networkPublisher<T: Decodable>(request: NetworkRequest,
                                        type: T.Type) -> AnyPublisher<T, NetworkError>
}

struct BasicNetworkService {
    private let session: URLSession
    private let decoder: JSONDecoder

    init() {
        self.session = URLSession(configuration: .default)
        self.decoder = JSONDecoder()
    }
}

// MARK: - Ext NetworkService
extension BasicNetworkService: NetworkService {
    func networkPublisher<T>(request: NetworkRequest, type: T.Type) -> AnyPublisher<T, NetworkError> where T : Decodable {
        guard let urlRequest = create(request) else {
            return Fail(error: NetworkError.badRequest).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                do {
                    return try self.parseResponse(data, response)
                } catch {
                    throw NetworkError.parseError
                }
            }
            .decode(type: type.self, decoder: decoder)
            .mapError { error in
                self.mapResponseError(error)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Ext UrlRequest
private extension BasicNetworkService {
    func create(_ request: NetworkRequest) -> URLRequest? {
        guard let url = request.endPoint else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        return urlRequest
    }
}

// MARK: - Ext Parse
private extension BasicNetworkService {
    func parseResponse(_ data: Data, _ response: URLResponse?) throws -> Data {
        // Check if the response is an HTTPURLResponse and has a status code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Check if the response status code is within the expected range (e.g., 200-299)
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse(httpResponse.statusCode)
        }
        
        return data
    }
}

// MARK: - Ext MapError
private extension BasicNetworkService {
    func mapResponseError(_ error: Error) -> NetworkError {
        switch error {
        case is URLError:
            return NetworkError.addressUnreachable
        default:
            return NetworkError.genericError("\(error)")
        }
    }
}
