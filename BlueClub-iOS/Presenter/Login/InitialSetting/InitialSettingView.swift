//
//  InitialSettingView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/5/24.
//

import ComposableArchitecture
import DesignSystem
import Domain
import SwiftUI
import Combine

struct InitialSettingView: View {
    
    typealias Reducer = InitialSetting
    @ObservedObject var viewStore: ViewStoreOf<Reducer>
    
    @FocusState var focus: Reducer.FocusItem?
    
    init(reducer: Reducer) {
        let store: StoreOf<Reducer> = .init(initialState: .init(), reducer: { reducer })
        self.viewStore = .init(store, observe: { $0 })
    }
    
    var body: some View {
        BaseView {
            header()
        } content: {
            content()
        } footer: {
            footer()
        }.sheet(isPresented: viewStore.$showAllowSheet) {
            ServiceAgreementSheet(
                isPresented: viewStore.$showAllowSheet,
                onFinish: { viewStore.send(.didFinishAllow) }
            ).presentationDetents([.height(488)])
        }.onChange(of: viewStore.nickname) { _ in
            viewStore.send(.nicknameDidChange)
        }.onReceive(Just(viewStore.targetIcome)) { _ in
            viewStore.send(.targetIncomeDidChange)
        }
        .hideKeyboardOnTapBackground()
        .syncFocused($focus, with: viewStore.$focus)
    }
}

// MARK: - header
extension InitialSettingView {
    
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
                let widthPerStage = (UIApplication.shared.screenSize?.width ?? .zero) /  CGFloat(InitialSetting.Stage.allCases.count)
                let width = widthPerStage * CGFloat(viewStore.currentStage.int)
                Rectangle()
                    .frame(height: 4)
                    .frame(width: width)
                    .foregroundStyle(Color.colors(.primaryNormal))
            }.animation(.default, value: viewStore.currentStage)
    }
}

// MARK: - content
@MainActor extension InitialSettingView {
    
    @ViewBuilder func content() -> some View {
        VStack(spacing: 0) {
            switch viewStore.currentStage {
            case .job:
                jobSelectionContent()
            case .targetIncome:
                targetIncomeContent()
            case .nickname:
                nicknameContent()
            case .welcome:
                welcomeContent()
            }
        }
    }
    
    @ViewBuilder func contentHeader() -> some View {
        VStack(spacing: 4) {
            Spacer()
            Text(viewStore.currentStage.headerTitle)
                .fontModifer(.h6)
                .foregroundStyle(Color.colors(.black))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(viewStore.currentStage.headerDescription)
                .fontModifer(.b2m)
                .foregroundStyle(Color.init(hex: "7C7C7C"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 22)
        }
        .padding(.horizontal, 20)
        .frame(height: 136)
    }
    
    @ViewBuilder func jobSelectionContent() -> some View {
        VStack(spacing: 0) {
            contentHeader()
            VStack(spacing: 12) {
                ForEach(JobOption.allCases, id: \.title) { option in
                    PrimaryButton(
                        title: option.title,
                        disabled: viewStore.selectedJob != option,
                        type: .outline,
                        action: {
                            viewStore.send(.didSelectJob(option), animation: .default)
                        }
                    )
                }
            }
        }
    }
    
    @ViewBuilder func targetIncomeContent() -> some View {
        VStack(spacing: 0) {
            contentHeader()
            VStack(spacing: 2) {
                HStack(spacing: 2) {
                    TextField("", text: viewStore.$targetIcome)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .focused($focus, equals: .targetIcome)
                    Text("원")
                        .hide(when: viewStore.targetIcome.isEmpty)
                }
                .fontModifer(.b1)
                .frame(height: 24)
                .foregroundStyle(Color.colors(.gray10))
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .background(alignment: .trailing, content: {
                    if viewStore.targetIcome.isEmpty {
                        Text("목표 금액 입력")
                            .fontModifer(.b1)
                            .foregroundStyle(Color.colors(.gray06))
                            .padding(.trailing, 12)
                    }
                })
                .roundedBackground(
                    .colors(.gray01),
                    radius: 8
                )
                if let message = viewStore.targetIcomeMessage {
                    Text(message.message)
                        .fontModifer(.caption1)
                        .foregroundStyle(message.color)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .frame(height: 18)
                        .padding(.horizontal, 8)
                }
            }.padding(.horizontal, 20)
        }.onAppear { focus = .targetIcome }
    }
    
    @ViewBuilder func nicknameContent() -> some View {
        VStack(spacing: 0) {
            contentHeader()
            VStack(spacing: 2) {
                TextInput(
                    text: viewStore.$nickname,
                    placeholder: "닉네임을 입력해주세요",
                    focusState: $focus,
                    focusValue: .nickname
                ).overlay(alignment: .trailing) {
                    
                    Text("중복확인")
                        .fontModifer(.sb3)
                        .foregroundStyle(Color.colors(.white))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 6)
                        .roundedBackground(
                            viewStore.checkNicknameDisabled
                            ? .colors(.gray04)
                            : .colors(.gray10),
                            radius: 4
                        )
                        .onTapGesture { viewStore.send(.checkNickname) }
                        .padding(.trailing, 12)
                }
                
                HStack {
                    HStack(spacing: 3) {
                        Text("\(viewStore.nickname.count)")
                            .foregroundStyle(Color.colors(.gray07))
                        Text("/")
                            .foregroundStyle(Color.colors(.gray05))
                        Text("10")
                            .foregroundStyle(Color.colors(.gray07))
                    }.fontModifer(.caption1)
                    Spacer()
                    if let message = viewStore.nicknameMessage {
                        Text(message.message)
                            .fontModifer(.caption1)
                            .foregroundStyle(message.color)
                    }
                }
                .frame(height: 18)
                .padding(.horizontal, 8)
            }.padding(.horizontal, 20)
        }.onAppear { focus = .nickname }
    }
    
    @ViewBuilder func welcomeContent() -> some View {
        VStack(spacing: 0) {
            Image("welcome", bundle: .main)
                .padding(.top, 142)
            Text("블루클럽 가입을 축하드려요!")
                .fontModifer(.h6)
                .foregroundStyle(Color.colors(.black))
                .padding(.top, 20)
            Text("이제 열심히 근무 기록하고\n나의 근무활동을 자유롭게 자랑해봐요")
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
extension InitialSettingView {
    
    @ViewBuilder func footer() -> some View {
        switch viewStore.currentStage {
        case .targetIncome:
            let disabled = !viewStore.isTargetIcomeValid
            PrimaryButton(
                title: "다음",
                disabled: disabled,
                action: {
                    viewStore.send(.setStage(.nickname), animation: .default)
                }
            )
            .padding(.vertical, 20)
            .disabled(disabled)
        case .nickname:
            let disabled = !viewStore.nicknameAvailable
            PrimaryButton(
                title: "다음",
                disabled: disabled,
                action: {
                    viewStore.send(.showAllowSheet)
                }
            )
            .padding(.vertical, 20)
            .disabled(disabled)
        case .welcome:
            PrimaryButton(
                title: "바로 시작하기",
                action: { viewStore.send(.didFinishInitialSetting) }
            ).padding(.vertical, 20)
        default:
            EmptyView()
        }
    }
}

#Preview {
    InitialSettingView(reducer: .init(cooridonator: .init()))
}
