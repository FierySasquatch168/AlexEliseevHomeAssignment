//
//  EndpointValue.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

enum EndPointValue {
    case main
    
    var stringValue: String {
        switch self {
        case .main:
            return K.URLPaths.baseUrl
        }
    }
}
