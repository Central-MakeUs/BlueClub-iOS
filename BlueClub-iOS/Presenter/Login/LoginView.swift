//
//  LoginView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/11/24.
//

import SwiftUI
import Domain
import DesignSystem
import Utility

struct LoginView: View {

    @StateObject var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            header()
            Spacer()
            buttons()
        }
        .loadingSpinner(viewModel.isLoading)
        .onAppear { printLog() }
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
                    action: {
                        viewModel.send(.didSelectLoginMethod(method))
                    }
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
        case .apple:
            return "애플로 시작하기"
        }
    }
    
    var foreground: Color {
        switch self {
        case .kakao:
            return .init(hex: "3C1E1E")
        case .apple:
            return .colors(.white)
        }
    }
    
    var background: Color {
        switch self {
        case .kakao:
            return .init(hex: "FDE500")
        case .apple:
            return .colors(.black)
        }
    }
    
    var icon: Icons? {
        switch self {
        case .kakao:
            return .kakao
        case .apple:
            return .apple
        }
    }
}

#Preview {
    LoginView(viewModel: .init(coordinator: .init()))
}
