//
//  RouterDelegate.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

protocol RouterDelegate: AnyObject {
    func setupRootViewController(_ viewController: Presentable?)
}
