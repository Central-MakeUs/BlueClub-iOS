//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 2/9/24.
//

import SwiftUI

public struct SheetHandle: View {
    
    public init() { }
    
    public var body: some View {
        Image(.sheetHandle)
            .padding(.bottom, 20)
            .padding(.top, 8)
    }
}

#Preview {
    SheetHandle()
}
