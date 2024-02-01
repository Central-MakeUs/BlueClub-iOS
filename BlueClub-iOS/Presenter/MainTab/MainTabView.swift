//
//  MainTabView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/4/24.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

struct MainTabView: View {
    
    typealias Reducer = MainTab
    @ObservedObject var viewStore: ViewStoreOf<Reducer>
    
    init(state: Reducer.State) {
        let store: StoreOf<Reducer> = .init(initialState: state, reducer: { Reducer() })
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
                switch tab {
                case .home:
                    HomeView(state: .init())
                        .tag(tab)
                case .note:
                    ScheduleNoteView(state: .init())
                        .tag(tab)
                case .myPage:
                    MyPageView()
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

                VStack(spacing: 2) {
                    Image.icons(tab.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                    Text(tab.title)
                        .fontModifer(.sb3)
                        .frame(height: 18)
                }
                .frame(height: 40)
                .frame(width: 64)
                .padding(.vertical, 9)
                .foregroundColor(color)
                .onTapGesture { viewStore.send(.didTap(tab)) }
            }
        }
        .frame(height: 58)
        .padding(.horizontal, 36)
        .background(Color.white)
        .overlay(alignment: .top) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.colors(.cg02))
        }
    }
}


#Preview {
    MainTabView(state: .init())
}
