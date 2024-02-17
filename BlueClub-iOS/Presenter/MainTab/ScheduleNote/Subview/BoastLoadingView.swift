//
//  BoastLoadingView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/17/24.
//

import SwiftUI
import DesignSystem
import Navigator
import Lottie

struct BoastLoadingView: View {
    
    weak var navigator: Navigator?
    
    var body: some View {
        BaseView {
            AppBar(
                leadingIcon: (Icons.arrow_left, { 
                    navigator?.pop()
                }),
                title: nil)
        } content: {
            EmptyView()
        }.overlay {
            VStack(spacing: 20) {
                Circle()
                    .frame(height: 148)
                    .foregroundStyle(Color.colors(.primaryBackground))
                    .overlay {
                        LottieView(animation: .named("loadingCoin"))
                            .playing(loopMode: .loop)
                            .frame(
                                width: 110,
                                height: 100)
                    }
                VStack(spacing: 8) {
                    Text("근무기록 저장 후\n이미지로 추출중이에요")
                        .fontModifer(.h6)
                        .foregroundStyle(Color.colors(.black))
                        .lineLimit(2)
                    Text("열심히 수입인증 카드를 만들고있어요!")
                        .fontModifer(.sb2)
                        .foregroundStyle(Color.colors(.gray07))
                }
                .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    BoastLoadingView()
}
