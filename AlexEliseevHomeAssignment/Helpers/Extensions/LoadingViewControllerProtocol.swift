//
//  LoadingViewControllerProtocol.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 24.11.2023.
//

import UIKit

protocol LoadingViewControllerProtocol: UIViewController {
    var loadingView: CustomAnimatedView { get }
    func setupLoadingView()
}

extension LoadingViewControllerProtocol {
    func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 50),
            loadingView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
