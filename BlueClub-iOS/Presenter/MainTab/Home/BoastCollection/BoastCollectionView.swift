//
//  BoastCollectionView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/3/24.
//

import SwiftUI
import DesignSystem

struct BoastCollectionView: View {
    var body: some View {
        BaseView {
            AppBar(
                leadingIcon: (Icons.arrow_left, { }),
                title: "자랑하기 모음집")
        } content: {
            ScrollView {
                LazyVStack {
//                    ForEach(1...10, id: \.self) { count in
//                        Text("Placeholder \(count)")
//                    }
                }
            }
            .overlay {
                emptyPlaceHolder()
            }
        }
    }
    
    @ViewBuilder func emptyPlaceHolder() -> some View {
        VStack(spacing: 0) {
            Image(.errorCoin)
            VStack(spacing: 8) {
                Text("생성한 자랑하기가 없습니다")
                    .fontModifer(.h6)
                    .foregroundStyle(Color.colors(.black))
                Text("근무 기록을 작성하고\n자랑하기 버튼을 클릭하면 모을 수 있어요!")
                    .multilineTextAlignment(.center)
                    .fontModifer(.sb2)
                    .foregroundStyle(Color.colors(.gray07))
            }.padding(20)
            Button(action: {
                
            }, label: {
                Text("근무기록 작성하러가기")
                    .fontModifer(.sb2)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 13)
                    .roundedBackground(
                        .colors(.primaryNormal), radius: 12)
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.colors(.cg01))
    }
}

#Preview {
    BoastCollectionView()
}
