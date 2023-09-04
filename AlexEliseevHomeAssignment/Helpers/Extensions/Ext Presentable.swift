//
//  Ext Presentable.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import UIKit

protocol Presentable: AnyObject {
    func getVC() -> UIViewController?
}

extension UIViewController: Presentable {
    func getVC() -> UIViewController? {
        return self
    }
}
