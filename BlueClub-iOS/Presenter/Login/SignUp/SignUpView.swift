//
//  SignUpView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/5/24.
//

import Architecture
import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI

struct SignUpView: StoreView {
    
    typealias Reducer = SignUp
    typealias Store = StoreOf<Reducer>
    typealias ViewStore = ViewStoreOf<Reducer>
    
    let store: Store
    @ObservedObject var viewStore: ViewStore
    
    @FocusState var focusState: Bool?
    
    init(store: Store) {
        self.store = store
        self.viewStore = .init(store, observe: { $0 })
    }
    
    var body: some View {
        BaseView {
            header()
        } content: {
            content()
        } footer: {
            footer()
        }.sheet(isPresented: viewStore.$showSelectYearSheet) {
            selectYearView()
        }.sheet(isPresented: viewStore.$showAllowSheet) {
            allowView()
        } .onReceive(viewStore.nickname.publisher) { value in
            viewStore.send(.nicknameDidChange)
        }.syncFocused($focusState, with: viewStore.$showKeyboard)
    }
}

// MARK: - header
extension SignUpView {
    
    @ViewBuilder func header() -> some View {
        if viewStore.currentStage != .welcome {
            VStack(spacing: 0) {
                topBar()
                indicator()
            }
        }
    }
    
    @ViewBuilder func topBar() -> some View {
        HStack {
            Button(action: {
                viewStore.send(.didTapBack)
            }, label: {
                Image.icons(.arrow_left)
            })
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
        .frame(height: 28)
        .padding(12)
        .overlay {
            Text(viewStore.currentStage.title)
                .fontModifer(.sb1)
        }
    }
    
    @ViewBuilder func indicator() -> some View {
        Rectangle()
            .frame(height: 4)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.colors(.cg03))
            .overlay(alignment: .leading) {
                let widthPerStage = (UIApplication.shared.screenSize?.width ?? .zero) /  CGFloat(SignUp.Stage.allCases.count)
                let width = widthPerStage * CGFloat(viewStore.currentStage.int)
                Rectangle()
                    .frame(height: 4)
                    .frame(width: width)
                    .foregroundStyle(Color.colors(.primaryNormal))
            }.animation(.default, value: viewStore.currentStage)
    }
}

// MARK: - content
@MainActor extension SignUpView {
    
    @ViewBuilder func content() -> some View {
        VStack(spacing: 0) {
            switch viewStore.currentStage {
            case .job:
                contentHeader()
                jobSelectionContent()
            case .startYear:
                contentHeader()
                startYearContent()
            case .nickname:
                nicknameContent()
            case .welcome:
                welcomeContent()
            }
        }
    }
    
    @ViewBuilder func contentHeader() -> some View {
        Text("내 직업과 일치하는\n항목을 골라주세요")
            .fontModifer(.h6)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 48)
            .frame(height: 136)
    }
    
    @ViewBuilder func jobSelectionContent() -> some View {
        VStack(spacing: 12) {
            ForEach(JobOption.allCases, id: \.title) { option in
                PrimaryButton(
                    title: option.title,
                    disabled: viewStore.selectedJob != option,
                    type: .outline,
                    action: { viewStore.send(.didSelectJob(option), animation: .default) }
                )
            }
        }
    }
    
    @ViewBuilder func startYearContent() -> some View {
        VStack(spacing: 12) {
            PrimaryButton(
                title: viewStore.selectedJob?.title ?? "",
                disabled: false,
                type: .outline,
                action: { viewStore.send(.setStage(.job)) }
            )
            if let startYear = viewStore.startYear {
                PrimaryButton(
                    title: String(startYear),
                    disabled: false,
                    type: .outline,
                    action: { viewStore.send(.showSelectYearSheet) }
                )
            } else {
                AccessoryButton(
                    title: "근무 시작년도를 선택해주세요",
                    action: { viewStore.send(.showSelectYearSheet) }
                )
            }
        }
    }
    
    @ViewBuilder func nicknameContentHeader() -> some View {
        VStack(spacing: 4) {
            Text("닉네임을 설정해주세요")
                .fontModifer(.h6)
                .foregroundStyle(Color.colors(.black))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("닉네임은 언제든 수정이 가능해요.")
                .fontModifer(.b2m)
                .foregroundStyle(Color.init(hex: "7C7C7C"))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 62)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder func nicknameContent() -> some View {
        VStack(spacing: 22) {
            nicknameContentHeader()
            VStack(spacing: 2) {
                TextInput(
                    text: viewStore.$nickname,
                    placeholder: "닉네임을 입력해주세요",
                    focusState: $focusState,
                    focusValue: true)
                HStack {
                    if let message = viewStore.message {
                        Text(message.message)
                            .fontModifer(.caption1)
                            .foregroundStyle(message.color)
                    }
                    Spacer()
                    HStack(spacing: 3) {
                        Text("\(viewStore.nickname.count)")
                            .foregroundStyle(Color.colors(.gray07))
                        Text("/")
                            .foregroundStyle(Color.colors(.gray05))
                        Text("10")
                            .foregroundStyle(Color.colors(.gray07))
                    }.fontModifer(.caption1)
                }
                .frame(height: 18)
                .padding(.horizontal, 8)
            }.padding(.horizontal, 20)
        }.onAppear { focusState = true }
    }
    
    @ViewBuilder func welcomeContent() -> some View {
        VStack(spacing: 0) {
            Image("character", bundle: .main)
                .padding(.top, 142)
            Text("블루클럽 가입을 축하드립니다")
                .fontModifer(.h6)
                .foregroundStyle(Color.colors(.black))
                .padding(.top, 20)
            Text("이제 열심히 근무 기록하고\n나의 근무활동을 자랑할 일만 남았어요!")
                .fontModifer(.sb2)
                .foregroundStyle(Color.colors(.gray07))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.top, 8)
            Spacer()
        }
    }
}

// MARK: - footer
extension SignUpView {
    
    @ViewBuilder func footer() -> some View {
        switch viewStore.currentStage {
        case .startYear:
            PrimaryButton(
                title: "다음",
                disabled: viewStore.startYear == .none,
                action: {
                    viewStore.send(.setStage(.nickname), animation: .default)
                }
            ).padding(.vertical, 20)
        case .nickname:
            PrimaryButton(
                title: "다음",
                action: { 
                    viewStore.send(.showAllowSheet)
                }
            ).padding(.vertical, 20)
        case .welcome:
            PrimaryButton(
                title: "바로 시작하기",
                action: { viewStore.send(.didFinishSignUp) }
            ).padding(.vertical, 20)
        default:
            EmptyView()
        }
    }
}

// MARK: - sheet
@MainActor extension SignUpView {
    
    @ViewBuilder func selectYearView() -> some View {
        SelectYearView(
            isPresented: viewStore.$showSelectYearSheet,
            selectedYear: viewStore.$startYear
        ).presentationDetents([.height(460)])
    }
    
    @ViewBuilder func allowView() -> some View {
        AllowSheetView(
            isPresented: viewStore.$showAllowSheet,
            onFinish: { viewStore.send(.didFinishAllow) }
        ).presentationDetents([.height(488)])
    }
}

#Preview {
    SignUpView(store: .init(initialState: .init(), reducer: {
        SignUpView.Reducer(cooridonator: .init())
    }))
}
