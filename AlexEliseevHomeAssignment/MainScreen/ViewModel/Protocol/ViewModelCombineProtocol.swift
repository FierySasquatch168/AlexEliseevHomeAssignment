//
//  ViewModelCombineProtocol.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 24.11.2023.
//

import Foundation
import Combine

protocol ViewModelCombineProtocol: MainViewModelProtocol
& ErrorProcessProtocol
& SearchableViewModelProtocol
& ScrollPaginationProtocol
& FavouriteSelectable {}

protocol MainViewModelProtocol {
    var visibleObjectsPublisher: CurrentValueSubject<[VisibleCharacterModel], Never> { get }
}

protocol SearchableViewModelProtocol {
    func searchFor(_ text: String)
}

protocol ScrollPaginationProtocol {
    func didScrollForNextPage(row: Int?)
}

protocol FavouriteSelectable {
    func selectFavourite(at: IndexPath?)
    func currentFavourite() -> IndexPath?
}
