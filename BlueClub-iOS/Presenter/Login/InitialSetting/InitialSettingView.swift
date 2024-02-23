//
//  InitialSettingView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/5/24.
//

import DesignSystem
import Domain
import SwiftUI
import Combine

struct InitialSettingView: View {
    
    @StateObject var viewModel: InitialSettingViewModel
    @FocusState var focus: InitialSettingViewModel.FocusItem?
    
    init(viewModel: InitialSettingViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        BaseView {
            header()
        } content: {
            content()
        } footer: {
            footer()
        }
        .sheet(isPresented: $viewModel.showAllowSheet) {
            ServiceAgreementSheet(
                isPresented: $viewModel.showAllowSheet,
                onFinish: { tos in
                    viewModel.send(.didFinishAllow(tos))
                }
            ).presentationDetents([.height(488)])
        }
        .hideKeyboardOnTapBackground()
        .syncFocused($focus, with: $viewModel.focus)
        .onChange(of: viewModel.nickname, { _, _ in
            viewModel.send(.nicknameDidChange)
        })
    }
}

// MARK: - header
extension InitialSettingView {
    
    @ViewBuilder func header() -> some View {
        if viewModel.currentStage != .welcome {
            VStack(spacing: 0) {
                topBar()
                indicator()
            }
        }
    }
    
    @ViewBuilder func topBar() -> some View {
        HStack {
            Button(action: {
                viewModel.send(.didTapBack)
            }, label: {
                Image.icons(.arrow_left)
            })
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
        .frame(height: 28)
        .padding(12)
        .overlay {
            Text(viewModel.currentStage.title)
                .fontModifer(.sb1)
        }
    }
    
    @ViewBuilder func indicator() -> some View {
        Rectangle()
            .frame(height: 4)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.colors(.cg03))
            .overlay(alignment: .leading) {
                let widthPerStage = (UIApplication.shared.screenSize.width) /  CGFloat(InitialSettingViewModel.Stage.allCases.count)
                let width = widthPerStage * CGFloat(viewModel.currentStage.int)
                Rectangle()
                    .frame(height: 4)
                    .frame(width: width)
                    .foregroundStyle(Color.colors(.primaryNormal))
            }.animation(.default, value: viewModel.currentStage)
    }
}

// MARK: - content
@MainActor extension InitialSettingView {
    
    @ViewBuilder func content() -> some View {
        VStack(spacing: 0) {
            switch viewModel.currentStage {
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
            Text(viewModel.currentStage.headerTitle)
                .fontModifer(.h6)
                .foregroundStyle(Color.colors(.black))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(viewModel.currentStage.headerDescription)
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
                        disabled: viewModel.selectedJob != option,
                        type: .outline,
                        action: {
                            withAnimation {
                                viewModel.send(.didSelectJob(option))
                            }
                        }
                    )
                }
            }
        }
    }
    
    @ViewBuilder func targetIncomeContent() -> some View {
        VStack(spacing: 0) {
            contentHeader()
            GoalInput(
                text: $viewModel.targetIncome, 
                isValid: $viewModel.isTargetIcomeValid,
                focusState: $focus,
                focusValue: .targetIcome)
        }.onAppear { focus = .targetIcome }
    }
    
    @ViewBuilder func nicknameContent() -> some View {
        VStack(spacing: 0) {
            contentHeader()
            NicknameInputContainer(
                isLoading: viewModel.isLoading,
                nickname: viewModel.nickname,
                isValid: viewModel.checkNicknameValid,
                message: viewModel.nicknameMessage,
                onTapCheck: { viewModel.send(.checkNickname) }
            ) {
                TextInput(
                    text: $viewModel.nickname,
                    placeholder: "닉네임을 입력해주세요",
                    focusState: $focus,
                    focusValue: .nickname
                )
            }
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
        switch viewModel.currentStage {
        case .targetIncome:
            let disabled = !viewModel.isTargetIcomeValid
            PrimaryButton(
                title: "다음",
                disabled: disabled,
                action: {
                    withAnimation {
                        viewModel.send(.setStage(.nickname))
                    }
                }
            )
            .padding(.vertical, 20)
            .disabled(disabled)
        case .nickname:
            let disabled = !viewModel.nicknameAvailable
            PrimaryButton(
                title: "다음",
                disabled: disabled,
                action: {
                    viewModel.send(.showAllowSheet)
                }
            )
            .padding(.vertical, 20)
            .disabled(disabled)
        case .welcome:
            PrimaryButton(
                title: "바로 시작하기",
                action: { viewModel.send(.home) }
                
            ).padding(.vertical, 20)
        default:
            EmptyView()
        }
    }
}

#Preview {
    InitialSettingView(viewModel: .init(cooridonator: .init()))
}
