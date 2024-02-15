//
//  File.swift
//  
//
//  Created by 김인섭 on 1/5/24.
//

import UIKit

public extension UINavigationController {
    
    static var `default`: UINavigationController {
        let controller = UINavigationController()
        controller.setNavigationBarHidden(true, animated: true)
        return controller
    }
}


extension UINavigationController: UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
