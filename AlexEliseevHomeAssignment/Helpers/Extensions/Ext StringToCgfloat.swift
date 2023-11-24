//
//  Ext StringToCgfloat.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

extension String {
    func toCGFloat() -> CGFloat {
        guard let floatValue = Float(self) else { return 50 }
        return CGFloat(floatValue)
    }
}
