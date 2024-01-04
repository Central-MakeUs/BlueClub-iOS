//
//  MainTabView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

fileprivate typealias viewStore = ViewStore<MainTab.State, MainTab.Action>

struct MainTabView: View {
    
    @State var store = Store(initialState: MainTab.State()) {
        MainTab()
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                content(viewStore)
                tabBar(viewStore)
            }
        }
    }
}

@MainActor private extension MainTabView {
    
    @ViewBuilder func content(_ viewStore: viewStore) -> some View {
        TabView(selection: viewStore.$currentTab) {
            ForEach(MainTab.TabItem.allCases, id: \.title) { tab in
                Text(tab.title)
                    .tag(tab)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder func tabBar(_ viewStore: viewStore) -> some View {
        LazyVGrid(columns: Array(repeating: .init(spacing: 0), count: 4)) {
            ForEach(MainTab.TabItem.allCases, id: \.title) { tab in
                
                let selected = viewStore.state.currentTab == tab
                let icon = selected ? tab.selectedIcon : tab.icon
                let color: Color = selected ? Color.colors(.primaryNormal) : Color.colors(.gray07)

                VStack(spacing: 0) {
                    Image.icons(icon)
                        .padding(.top, 6)
                    Text(tab.title)
                        .fontModifer(.caption2)
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .foregroundColor(color)
                .onTapGesture {
                    viewStore.send(.didTap(tab))
                }
            }
        }
        .frame(height: 50)
        .background(Color.white)
        .shadow(
            color: .black.opacity(0.15),
            radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/,
            x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 4
        )
    }
}


#Preview {
    MainTabView()
}
