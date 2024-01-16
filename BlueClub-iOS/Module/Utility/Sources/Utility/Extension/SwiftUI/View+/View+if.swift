//
//  File.swift
//  
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func ifElse<ifContent: View, elseContent: View>(
        _ condition: Bool,
        _ ifContentBuilder: (Self) -> ifContent,
        _ elseContentBuilder: (Self) -> elseContent
    ) -> some View {
        if condition {
            ifContentBuilder(self)
        } else {
            elseContentBuilder(self)
        }
    }
    
    @ViewBuilder func `if`<ifContent: View>(
        _ condition: Bool,
        _ ifContentBuilder: (Self) -> ifContent
    ) -> some View {
        if condition {
            ifContentBuilder(self)
        } else {
            self
        }
    }
}
