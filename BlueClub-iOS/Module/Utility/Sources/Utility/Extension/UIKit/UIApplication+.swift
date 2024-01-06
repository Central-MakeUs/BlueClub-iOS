//
//  File.swift
//  
//
//  Created by 김인섭 on 1/5/24.
//

import UIKit

public extension UIApplication {
    
    var scene: UIWindowScene? {
        UIApplication
            .shared
            .connectedScenes
            .first as? UIWindowScene
    }
    
    var window: UIWindow? {
        scene?
            .windows
            .first(where: { $0.isKeyWindow })
    }
    
    var rootController: UIViewController? {
        window?.rootViewController
    }
    
    var screenSize: CGRect? {
        rootController?.view.frame
    }
    
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
