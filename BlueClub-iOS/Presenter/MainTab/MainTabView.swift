//
//  MainTabView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Architecture

struct MainTabView: StoreView {
    
    typealias Reducer = MainTab
    typealias Store = StoreOf<Reducer>
    typealias ViewStore = ViewStoreOf<Reducer>
    
    let store: Store
    @ObservedObject var viewStore: ViewStore
    
    init(store: Store = .init(initialState: .init(), reducer: { Reducer() })) {
        self.store = store
        self.viewStore = .init(store, observe: { $0 })
    }
    
    var body: some View {
        BaseView {
            content()
        } footer: {
            tabBar()
        }.ignoresSafeArea(edges: .top)
    }
}

@MainActor private extension MainTabView {
    
    @ViewBuilder func content() -> some View {
        TabView(selection: viewStore.$currentTab) {
            ForEach(MainTab.TabItem.allCases, id: \.title) { tab in
                if tab == .home {
                    HomeView()
                        .tag(tab)
                } else {
                    Text(tab.title)
                        .tag(tab)
                }
            }.toolbar(.hidden, for: .tabBar)
        }
    }
    
    @ViewBuilder func tabBar() -> some View {
        LazyVGrid(columns: Array(repeating: .init(), count: 3)) {
            ForEach(MainTab.TabItem.allCases, id: \.title) { tab in
                
                let selected = viewStore.state.currentTab == tab
                let color: Color = selected
                ? Color.colors(.primaryNormal) 
                : Color.colors(.gray05)

                VStack(spacing: 2.25) {
                    Image.icons(tab.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                    Text(tab.title)
                        .fontModifer(.sb3)
                        .frame(height: 18)
                }
                .frame(height: 48)
                .frame(width: 80)
                .padding(.top, 2)
                .foregroundColor(color)
                .onTapGesture {
                    viewStore.send(.didTap(tab))
                }
            }
        }
        .frame(height: 56)
        .padding(.horizontal, 42)
        .background(Color.white)
        .overlay(alignment: .top) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.colors(.cg02))
        }
    }
}


#Preview {
    MainTabView(store: .init(initialState: .init(), reducer: {
        MainTabView.Reducer()
    }))
}
