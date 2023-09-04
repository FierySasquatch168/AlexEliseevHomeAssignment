//
//  QueryItems.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

enum QueryItems {
    case main
    case characterName
    
    var stingValue: String {
        switch self {
        case .main:
            return K.URLPaths.baseQuery
        case .characterName:
            return K.URLPaths.peopleQuery
        }
    }
}
