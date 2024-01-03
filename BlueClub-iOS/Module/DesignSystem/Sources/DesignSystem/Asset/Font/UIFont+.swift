//
//  File.swift
//  
//
//  Created by 김인섭 on 1/3/24.
//

import UIKit

public extension UIFont {
    
    enum FontWeight: String, CaseIterable {
        case bold = "Pretendard-Bold"
        case semiBold = "Pretendard-SemiBold"
        case regular = "Pretendard-Regular"
    }
    
    static func designSystem(_ weight: FontWeight, size: CGFloat) -> UIFont {
        return .init(name: weight.rawValue, size: size)!
    }
    
    static func registerFonts() {
        for font in FontWeight.allCases {
            UIFont.registerFont(bundle: Bundle.module, fontName: font.rawValue)
        }
    }
    
    static func registerFont(bundle: Bundle, fontName: String) {
        guard let pathForResourceString = bundle.path(forResource: fontName, ofType: ".otf"),
              let fontData = NSData(contentsOfFile: pathForResourceString),
              let dataProvider = CGDataProvider(data: fontData),
              let fontRef = CGFont(dataProvider)
        else {
            print("Failed to register font - bundle identifier invalid.")
            return
        }

        var errorRef: Unmanaged<CFError>? = nil
        
        if CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false {
            print("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}
