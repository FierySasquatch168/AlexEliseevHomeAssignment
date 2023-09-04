//
//  VisibleCharacterModel.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

struct VisibleCharacterModel: Hashable {
    let id = UUID().uuidString
    let name: String
    let height: String
    var favourite: Bool
}
