//
//  RequestResult.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import UIKit

enum RequestResult {
    case loading
    
    var image: UIImage? {
        switch self {
        case .loading:
            return UIImage(systemName: K.Icons.circleDotted)
        }
    }
}
