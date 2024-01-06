//
//  LoginInitialView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/5/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct SignUpEntryView: View {
    
    typealias ViewStoreType = ViewStore<SignUpEntry.State, SignUpEntry.Action>
    typealias StoreType = Store<SignUpEntry.State, SignUpEntry.Action>
    
    @State var store: StoreType
    
    init(store: StoreType) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            BaseView {
                VStack {
                    rotatingBanner(viewStore)
                    description()
                }.padding(.top, 96)
            } footer: {
                PrimaryButton(
                    title: "직업 설정하고 시작하기",
                    action: { viewStore.send(.didTapButton) }
                ).padding(.bottom, 70)
            }
            .onAppear { viewStore.send(.onAppear) }
            .onDisappear { viewStore.send(.onDisppaer) }
        }
    }
}

// MARK: - Sub Views
@MainActor extension SignUpEntryView {
    
    @ViewBuilder func rotatingBanner(_ viewStore: ViewStoreType) -> some View {
        
        VStack(spacing: 12) {
            viewStore.currentTab.image
                .transition(
                    .move(edge: .bottom)
                    .combined(with: .opacity)
                )
            HStack(spacing: 12) {
                ForEach(SignUpEntry.TabItem.allCases, id: \.self) { tab in
                    Circle()
                        .frame(width: 8)
                        .foregroundStyle(
                            viewStore.currentTab == tab
                            ? Color.colors(.cg05)
                            : Color.colors(.cg03)
                        )
                }
            }
        }
        .padding(.vertical, 16)
        .frame(height: 352)
        .frame(maxWidth: .infinity)
   }
    
    @ViewBuilder func description() -> some View {
        VStack(spacing: 12) {
            Text("특수고용직의 파트너, 블루클럽")
                .fontModifer(.h6)
                .foregroundStyle(Color.colors(.black))
            Text("특수고용직군을 위한 근무관리 서비스를 통해 수입관리하고 종사자끼리 커뮤니티로 소통해요")
                .fontModifer(.b2)
                .foregroundStyle(Color.colors(.gray07))
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 68)
    }
}

#Preview {
    SignUpEntryView(
        store: .init(initialState: SignUpEntry.State(), reducer: {
            SignUpEntry(coordinator: .init())
        })
    )
}
