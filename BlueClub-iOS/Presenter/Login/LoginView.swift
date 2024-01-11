//
//  LoginView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/11/24.
//

import SwiftUI
import ComposableArchitecture
import Domain
import Architecture
import DesignSystem

struct LoginView: StoreView {
    
    typealias Reducer = Login
    typealias Store = StoreOf<Reducer>
    typealias ViewStore = ViewStoreOf<Reducer>
    
    let store: Store
    @ObservedObject var viewStore: ViewStore
    
    init(store: Store) {
        self.store = store
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
                    action: { store.send(.didSelectLoginMethod(method)) }
                )
            }
        }.padding(.bottom, 70)
    }
}

#Preview {
    LoginView(store: .init(initialState: .init(), reducer: {
        Login(coordinator: .init(), dependencies: .init())
    }))
}
