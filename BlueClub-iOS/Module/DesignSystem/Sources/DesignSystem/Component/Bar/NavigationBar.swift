//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/12/24.
//

import SwiftUI

struct NavigationBar: View {
    
    let leadingIcon: (Icons, () -> Void)
    let title: String
    
    init(
        leadingIcon: (Icons, () -> Void),
        title: String
    ) {
        self.leadingIcon = leadingIcon
        self.title = title
    }
    
    var body: some View {
        HStack {
            Button(action: {
                leadingIcon.1()
            }, label: {
                Image.icons(leadingIcon.0)
            })
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
        .frame(height: 28)
        .padding(12)
        .overlay {
            Text(title)
                .fontModifer(.sb1)
        }
    }
}

#Preview {
    NavigationBar(
        leadingIcon: (Icons.arrow_left, { }),
        title: "설정"
    )
}
