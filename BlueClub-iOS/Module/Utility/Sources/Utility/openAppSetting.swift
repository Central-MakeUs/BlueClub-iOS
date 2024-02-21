//
//  File.swift
//  
//
//  Created by 김인섭 on 2/22/24.
//

import Foundation
import UIKit

public func openAppSetting() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
}
