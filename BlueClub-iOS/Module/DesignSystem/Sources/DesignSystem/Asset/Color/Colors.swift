//
//  ColorSystem.swift
//
//
//  Created by 김인섭 on 1/3/24.
//

import SwiftUI

public enum Colors {
    
    // gray
    case gray01
    case gray02
    case gray03
    case gray04
    case gray05
    case gray06
    case gray07
    case gray08
    case gray09
    case gray10
    
    // coolgray
    case cg01
    case cg02
    case cg03
    case cg04
    case cg05
    case cg06
    case cg07
    case cg08
    case cg09
    case cg10
    
    // primary
    case primaryDark
    case primaryLight
    case primaryNormal
    case primaryBackground
    
    // basic
    case black
    case white
    
    // system
    case error
    
    var hex: String {
        switch self {
            
        // gray
        case .gray01:
            "#f9f9f9"
        case .gray02:
            "#f3f3f3"
        case .gray03:
            "#eaeaea"
        case .gray04:
            "#dadada"
        case .gray05:
            "#b7b7b7"
        case .gray06:
            "#979797"
        case .gray07:
            "#6e6e6e"
        case .gray08:
            "#5b5b5b"
        case .gray09:
            "#3c3c3c"
        case .gray10:
            "#1c1c1c"
            
        // coolgray
        case .cg01:
            "#F7FAFC"
        case .cg02:
            "#EDF2F7"
        case .cg03:
            "#E2E8F0"
        case .cg04:
            "#CBD5E0"
        case .cg05:
            "#A0AEC0"
        case .cg06:
            "#718096"
        case .cg07:
            "#626F85"
        case .cg08:
            "#4A5568"
        case .cg09:
            "#2D3748"
        case .cg10:
            "#1A202C"
            
        // primary
        case .primaryDark:
            "#1861F1"
        case .primaryLight:
            "#6EA8FF"
        case .primaryNormal:
            "#2D75FF"
        case .primaryBackground:
            "#E6F1FF"
            
        // basic
        case .black:
            "#191919"
        case .white:
            "#FFFFFF"
            
        // system
        case .error:
            "#FE1D30"
        }
    }
}
