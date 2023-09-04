//
//  Ext LoadingAnimationUpdate.swift
//  AlexEliseevHomeAssignment
//
//  Created by Aleksandr Eliseev on 03.09.2023.
//

import UIKit

extension UIViewController {
    func showOrHideAnimation(_ view: CustomAnimatedView,for requestResult: RequestResult?) {
        guard let requestResult
        else {
            view.stopAnimation()
            return
        }
        
        view.result = requestResult
        view.startAnimation()
    }
}
