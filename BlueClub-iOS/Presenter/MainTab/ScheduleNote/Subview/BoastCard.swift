//
//  BoastCard.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/13/24.
//

import SwiftUI
import DesignSystem
import Domain

struct BoastCard: View {
    
    let boast: BoastDTO
    var isBronze: Bool {
        boast.imageName == "bronzeCoin"
    }
    var title: String {
        isBronze
            ? "오늘 근무도"
            : "\(boast.job)중"
    }
    var description: String {
        isBronze
            ? "고생했어요"
            : boast.rank
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .fontModifer(.sb2)
                    Text(description)
                        .fontModifer(.h4)
                }.foregroundStyle(Color.colors(.white))
                Spacer()
                Text(boast.dateLabel)
                    .fontModifer(.sb2)
                    .foregroundStyle(Color.colors(.primaryBackground))
            }
            
            Circle()
                .frame(width: 182)
                .foregroundStyle(Color.white)
                .overlay {
                    Image(boast.imageName, bundle: .main)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 170)
                }
                .padding(.bottom, 4)
            
            HStack(alignment: .top, spacing: 8) {
                ChipView("수입")
                    .padding(.top, 2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(boast.income.withComma() + "원")
                        .fontModifer(.h6)
                        .frame(height: 28)
                    if let cases = boast.cases {
                        Text("총 \(cases)건 수행")
                            .fontModifer(.sb1)
                    }
                }
                .foregroundStyle(Color.white)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 30)
            .padding(.vertical, 16)
            .roundedBackground(Color.white.opacity(0.15))
            
            HStack(spacing: 2) {
                Text("수입인증 BLUECLUB")
                    .fontModifer(.caption3)
                Image(.checkBadge)
            }.foregroundStyle(Color.colors(.primaryBackground))
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black,
                    Color(hex: "2d71fa")]),
                startPoint: .top, endPoint: .bottom
            ).roundedBackground()
        )
        .frame(height: 426)
    }
}

#Preview {
    BoastCard(boast: .init(
        job: "골프캐디주",
        workAt: "2024-02-22",
        rank: "기타",
        income: 10500,
        cases: 3)
    )
}
