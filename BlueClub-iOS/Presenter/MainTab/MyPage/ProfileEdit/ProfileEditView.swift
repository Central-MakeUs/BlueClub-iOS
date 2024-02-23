//
//  ProfileEditView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/8/24.
//

import SwiftUI
import DesignSystem
import Combine

struct ProfileEditView: View {
    
    @StateObject var viewModel: ProfileEditViewModel
    
    init(viewModel: ProfileEditViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    @FocusState var nicknameFocus: Bool?
    @FocusState var monthlyGoalFocus: Bool?
    
    var body: some View {
        BaseView {
            AppBar(
                leadingIcon: (Icons.arrow_left, { 
                    viewModel.send(.pop)
                }),
                title: "프로필 수정",
                isTrailingButtonActive: viewModel.isAvailable,
                trailingButton: ("저장", { 
                    viewModel.send(.didTapEdit)
                }))
        } content: {
            ScrollView {
                VStack(spacing: 0) {
                    contentHeader()
                    nicknameInput()
                    jobInput()
                    monthlyGoalInput()
                    footer()
                }.hideKeyboardOnTapBackground()
            }
        }
        .sheet(isPresented: $viewModel.showJobSelect) {
            JobSelectSheet(
                isShow: $viewModel.showJobSelect,
                onSelect: { viewModel.job = $0 }
            ).presentationDetents([.height(282)])
        }
        .onChange(of: viewModel.nickname, { _, _ in
            viewModel.send(.nicknameDidChange)
        })
        .loadingSpinner(viewModel.isLoading)
    }
}

extension ProfileEditView {
    
    @ViewBuilder func contentHeader() -> some View {
        Image(.myPageIcon)
            .resizable()
            .scaledToFit()
            .frame(width: 100)
            .padding(.vertical, 24)
    }
    
    @ViewBuilder func nicknameInput() -> some View {
        VStack(spacing: 0) {
            sectionHeader(title: "닉네임")
            NicknameInputContainer(
                nickname: viewModel.nickname,
                isValid: viewModel.nicknameValid,
                message: viewModel.nicknameMessage,
                onTapCheck: { viewModel.send(.chekcDuplicate) }
            ) {
                TextInput(
                    text: $viewModel.nickname,
                    placeholder: "",
                    focusState: $nicknameFocus,
                    focusValue: true)
            }
        }.padding(.bottom, 16)
    }
    
    @ViewBuilder func jobInput() -> some View {
        VStack(spacing: 0) {
            sectionHeader(title: "직업")
            Button(action: {
                viewModel.send(.showJobSelect)
            }, label: {
                HStack {
                    Text(viewModel.job.title)
                        .foregroundStyle(Color.colors(.gray08))
                        .fontModifer(.b1)
                    Spacer()
                    Image.icons(.arrow_bottom)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .roundedBackground(Color.colors(.gray01))
                .padding(.horizontal, 20)
            }).buttonStyle(.plain)
        }
        .padding(.bottom, 36)
    }
    
    @ViewBuilder func monthlyGoalInput() -> some View {
        VStack(spacing: 0) {
            sectionHeader(title: "매달 목표 수입")
            GoalInput(
                text: $viewModel.monthlyGoal,
                isValid: $viewModel.monthlyGoalValid,
                focusState: $monthlyGoalFocus,
                focusValue: true)
        }
        .padding(.bottom, 36)
    }
    
    @ViewBuilder func sectionHeader(title: String) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(title)
                .fontModifer(.sb2)
                .foregroundStyle(Color.colors(.gray09))
            Text("*")
                .foregroundStyle(Color.colors(.error))
            Spacer()
        }
        .frame(height: 28)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder func footer() -> some View {
        HStack(spacing: 16) {
            Button(action: {
                viewModel.send(.logoutAlert)
            }, label: {
                footerCell(title: "로그아웃")
            })
            Rectangle()
                .frame(width: 1)
                .foregroundStyle(Color.colors(.gray03))
            Button(action: {
                viewModel.send(.withdrawAlert)
            }, label: {
                footerCell(title: "회원탈퇴")
            })
        }
        .frame(height: 20)
        .padding(20)
    }
    
    @ViewBuilder func footerCell(title: String) -> some View {
        Text(title)
            .fontModifer(.sb2)
            .foregroundStyle(Color.colors(.gray09))
    }
}

#Preview {
    ProfileEditView(
        viewModel: .init(
            coordinator: .init(
                navigator: .init())))
}
