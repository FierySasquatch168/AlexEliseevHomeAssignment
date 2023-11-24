//
//  VisibleCharacterModel.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

struct VisibleCharacterModel: Hashable {
    let id: String
    let name: String
    let height: String
    var favourite: Bool
    
    init(character: StarWarsCharacter, isFavourite: Bool) {
        self.id = character.id
        self.name = character.name
        self.height = character.height
        self.favourite = isFavourite
    }
    
    func getFloatHeight() -> CGFloat {
        return self.height.toCGFloat()
    }
}
