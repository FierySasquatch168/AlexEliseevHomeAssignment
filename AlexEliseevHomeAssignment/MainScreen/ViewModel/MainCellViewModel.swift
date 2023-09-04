//
//  MainCellViewModel.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

final class MainCellViewModel {
    @Published private (set) var character: VisibleCharacterModel
    
    init(character: VisibleCharacterModel) {
        self.character = character
    }
}
