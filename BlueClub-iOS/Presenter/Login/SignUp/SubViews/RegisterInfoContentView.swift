//
//  RegisterInfoContentView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/7/24.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

extension SignUpView {
 
    struct RegisterInfoContentView: View {
        
        private let store: SignUpView.Store
        @ObservedObject private var viewStore: SignUpView.ViewStore
        @FocusState var focusState: SignUp.FocusItem?
        
        init(store: SignUpView.Store) {
            self.store = store
            self.viewStore = .init(store, observe: { $0 })
        }
        
        var body: some View {
            ScrollView {
                VStack(spacing: 36) {
                    emailSection()
                    passwordSection()
                    nameSection()
                    phoneNumberSection()
                    allowSection()
                }
                .padding(.vertical, 24)
                .hideKeyboardOnTapBackground()
            }
            .scrollDismissesKeyboard(.immediately)
            .onAppear { viewStore.send(.setFocusState(.email)) }
        }
    }
}

@MainActor extension SignUpView.RegisterInfoContentView {
    
    @ViewBuilder func emailSection() -> some View {
        InputContainer(title: ("이메일", true)) {
            TextInput(
                text: viewStore.$email,
                placeholder: "이메일 입력",
                focusState: $focusState,
                followingState: viewStore.$focusState,
                focusValue: .email,
                trailingButton: {
                    TrailingButton(
                        title: "중복확인",
                        isActive: !viewStore.email.isEmpty,
                        action: { }
                    )
                }
            ).onSubmit { viewStore.send(.setFocusState(.password)) }
        }
    }
    
    @ViewBuilder func passwordSection() -> some View {
        InputContainer(title: ("비밀번호", true)) {
            VStack(spacing: 0) {
                TextInput(
                    text: viewStore.$password,
                    placeholder: "6자 이상, 숫자와 영문자 조합",
                    focusState: $focusState,
                    followingState: viewStore.$focusState,
                    focusValue: .password,
                    hasDivider: true
                ).onSubmit { viewStore.send(.setFocusState(.passwordConfirm)) }
                TextInput(
                    text: viewStore.$passwordConfirm,
                    placeholder: "비밀번호 재입력",
                    focusState: $focusState,
                    followingState: viewStore.$focusState,
                    focusValue: .passwordConfirm
                ).onSubmit { viewStore.send(.setFocusState(.name)) }
            }
        }
    }
    
    @ViewBuilder func nameSection() -> some View {
        InputContainer(title: ("이름", true)) {
            TextInput(
                text: viewStore.$name,
                placeholder: "이름 입력",
                focusState: $focusState,
                followingState: viewStore.$focusState,
                focusValue: .name
            ).onSubmit {  }
        }
    }
    
    @ViewBuilder func phoneNumberSection() -> some View {
        InputContainer(title: ("휴대폰 번호", true)) {
            VStack(spacing: 0) {
                AccessoryButton(
                    title: "통신사 선택",
                    background: .clear,
                    border: .none,
                    hPadding: 0,
                    action: { }
                ).padding(.leading, -4)
                TextInput(
                    text: viewStore.$phoneNumber,
                    placeholder: "01012345678",
                    focusState: $focusState,
                    followingState: viewStore.$focusState,
                    focusValue: .phoneNumber,
                    trailingButton: {
                        TrailingButton(
                            title: "본인인증",
                            isActive: !viewStore.phoneNumber.isEmpty,
                            action: { })
                    }
                )
                TextInput(
                    text: viewStore.$verificationCode,
                    placeholder: "인증번호 입력",
                    focusState: $focusState,
                    followingState: viewStore.$focusState,
                    focusValue: .verificationCode
                )
            }
        }.padding(.bottom, 10)
    }
    
    @ViewBuilder func allowSection() -> some View {
        AllowView(hasAllow: viewStore.$hasAllow)
    }
}

#Preview {
    SignUpView.RegisterInfoContentView(
        store: .init(initialState: SignUp.State(), reducer: {
            SignUp(cooridonator: .init())
        })
    )
}
