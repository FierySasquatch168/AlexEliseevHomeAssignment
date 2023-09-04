//
//  SceneDelegate.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let coordinatorFactory: CoordinatorFactoryProtocol = CoordinatorFactory()
    lazy private var router: Routable = Router(routerDelegate: self)
    lazy private var coordinator = coordinatorFactory.createFlowCoordinator(with: router)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        coordinator.start()
    }
}

extension SceneDelegate: RouterDelegate {
    func setupRootViewController(_ viewController: Presentable?) {
        guard let viewController = viewController?.getVC() else { return }
        window?.rootViewController = viewController
    }
}

