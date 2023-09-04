//
//  Router.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import Foundation

protocol Routable: AnyObject {
    func setupRootViewController(viewController: Presentable)
}

final class Router {
    weak var delegate: RouterDelegate?
    private var currentViewController: Presentable?
    
    init(routerDelegate: RouterDelegate) {
        delegate = routerDelegate
    }
}

extension Router: Routable {
    func setupRootViewController(viewController: Presentable) {
        currentViewController = viewController
        delegate?.setupRootViewController(currentViewController)
    }
}
