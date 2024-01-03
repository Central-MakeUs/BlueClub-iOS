//
//  FontSystem.swift
//
//
//  Created by 김인섭 on 1/3/24.
//

import UIKit

public enum Typography {
    
    case h1
    case h2
    case h3
    case h4
    case h5
    case h6
    
    case sb1(FontWeight)
    case sb2
    case sb3
    
    case b1
    case b2
    
    case caption1
    case caption2
    
    var uiFont: UIFont {
        switch self {
            
        case .h1:
            return .typography(.bold, size: 40)
        case .h2:
            return .typography(.bold, size: 36)
        case .h3:
            return .typography(.bold, size: 32)
        case .h4:
            return .typography(.bold, size: 28)
        case .h5:
            return .typography(.bold, size: 24)
        case .h6:
            return .typography(.bold, size: 20)
            
        case .sb1(let weight):
            return .typography(
                weight,
                size: (weight == .bold) ? 18 : 16
            )
        case .sb2:
            return .typography(.semiBold, size: 14)
        case .sb3:
            return .typography(.semiBold, size: 12)
            
        case .b1:
            return .typography(.regular, size: 16)
        case .b2:
            return .typography(.regular, size: 14)
            
        case .caption1:
            return .typography(.regular, size: 12)
        case .caption2:
            return .typography(.regular, size: 11)
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
            
        case .h1:
            return 52
        case .h2:
            return 46
        case .h3:
            return 42
        case .h4:
            return 38
        case .h5:
            return 34
        case .h6:
            return 28
            
        case .sb1(let weight):
            return (weight == .bold) ? 24 : 22
        case .sb2:
            return 20
        case .sb3:
            return 18
            
        case .b1:
            return 24
        case .b2:
            return 24
            
        case .caption1:
            return 18
        case .caption2:
            return 16
        }
    }
    
    var letterSpacing: CGFloat {
        
        switch self {
            
        case .b1, .b2, .caption1, .caption2:
            return -0.6
        default:
            return 0
        }
    }
}
