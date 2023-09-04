//
//  ResponseModel.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

struct ResponseModel: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [StarWarsCharacter]
}

struct StarWarsCharacter: Decodable, Hashable {
    let id = UUID().uuidString
    let name: String
    let height: String
}
