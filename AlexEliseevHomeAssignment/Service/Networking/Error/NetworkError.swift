//
//  NetworkError.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case addressUnreachable
    case invalidResponse
    case badResponse(Int)
    case badRequest
    case genericError(String)
    case parseError
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Response invalid"
        case .addressUnreachable:
            return "Unreachable URL"
        case .badRequest:
            return "Bad request"
        case .badResponse(let responseCode):
            return "Bad response with code \(responseCode)"
        case .genericError(let description):
            return "An error occurred: \(description)"
        case .parseError:
            return "Error occured when parsing"
        }
    }
}
