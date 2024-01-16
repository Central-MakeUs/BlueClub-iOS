//
//  LoginView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/11/24.
//

import SwiftUI
import ComposableArchitecture
import Domain
import DesignSystem

struct LoginView: View {
    
    typealias Reducer = Login
    @ObservedObject var viewStore: ViewStoreOf<Reducer>
    
    init(reducer: Reducer) {
        let store: StoreOf<Reducer> = .init(initialState: .init(), reducer: { reducer })
        self.viewStore = .init(store, observe: { $0 })
    }
    
    var body: some View {
        VStack {
            header()
            Spacer()
            buttons()
        }
    }
    
    @ViewBuilder func header() -> some View {
        VStack(spacing: 20) {
            Image("character", bundle: .main)
            VStack(spacing: 8) {
                Text("특수고용직의 파트너, 블루클럽")
                    .fontModifer(.h6)
                Text("근무 내용을 쉽게 기록하고\n수입을 다른 사람들에게 자랑해보세요!")
                    .fontModifer(.sb2)
                    .multilineTextAlignment(.center)
            }
        }.padding(.top, 144)
    }
    
    @ViewBuilder func buttons() -> some View {
        VStack(spacing: 10) {
            ForEach(LoginMethod.allCases, id: \.self) { method in
                CustomButton(
                    leadingIcon: method.icon,
                    title: method.buttonTitle,
                    foreground: method.foreground,
                    background: method.background,
                    action: { viewStore.send(.didSelectLoginMethod(method)) }
                )
            }
        }.padding(.bottom, 20)
    }
}

extension LoginMethod {
    
    var buttonTitle: String {
        switch self {
        case .kakao:
            return "카카오로 3초만에 시작하기"
        case .naver:
            return "네이버로 시작하기"
        case .apple:
            return "애플로 시작하기"
        }
    }
    
    var foreground: Color {
        switch self {
        case .kakao:
            return .init(hex: "3C1E1E")
        case .naver:
            return .colors(.white)
        case .apple:
            return .colors(.white)
        }
    }
    
    var background: Color {
        switch self {
        case .kakao:
            return .init(hex: "FDE500")
        case .naver:
            return .init(hex: "03C75A")
        case .apple:
            return .colors(.black)
        }
    }
    
    var icon: Icons? {
        switch self {
        case .kakao:
            return .kakao
        case .naver:
            return .naver
        case .apple:
            return .apple
        }
    }
}

#Preview {
    LoginView(reducer: .init(coordinator: .init(), dependencies: .init()))
}
