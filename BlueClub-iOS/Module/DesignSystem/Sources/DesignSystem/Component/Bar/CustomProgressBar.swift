//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/13/24.
//

import SwiftUI
import Utility

public struct CustomProgressBar: View {
    
    @State var backgroundWidth: CGFloat = .zero
    @State var progressWidth: CGFloat = .zero
    let progress: CGFloat
    let progressLocation: (CGFloat) -> Void
    
    public init(
        progress: CGFloat,
        progressLocation: @escaping (CGFloat) -> Void = { _ in }
    ) {
        self.progress = progress
        self.progressLocation = progressLocation
    }
    
    public var body: some View {
        RadiusRectangle(
            .colors(.cg03),
            height: 12,
            radius: 50
        ).getSize {
            self.backgroundWidth = $0.width
            self.progressWidth = $0.width * progress
            self.progressLocation(progressWidth)
        }.overlay(alignment: .leading) {
            RadiusRectangle(
                .colors(.primaryLight),
                height: 12,
                radius: 50
            )
            .frame(minWidth: 14)
            .frame(width: progressWidth)
        }
    }
}

#Preview {
    CustomProgressBar(progress: 0.2)
}
