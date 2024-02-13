//
//  File.swift
//  
//
//  Created by 김인섭 on 2/13/24.
//

import SwiftUI

public extension View {
    
    func snapshot(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
//        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
