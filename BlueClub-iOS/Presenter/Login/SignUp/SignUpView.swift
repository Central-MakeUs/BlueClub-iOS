//
//  SignUpView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/5/24.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Architecture

struct SignUpView: StoreView {
    
    typealias Reducer = SignUp
    typealias Store = StoreOf<Reducer>
    typealias ViewStore = ViewStoreOf<Reducer>
    
    let store: Store
    @ObservedObject var viewStore: ViewStore
    
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
        }
        .sheet(isPresented: viewStore.$showSelectYearSheet, content: {
            selectYearView()
        })
        .sheet(isPresented: viewStore.$showAllowSheet, content: {
            allowView()
        })
    }
}

// MARK: - header
extension SignUpView {
    
    @ViewBuilder func header() -> some View {
        VStack(spacing: 0) {
            topBar()
            indicator()
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
            case .jobSelection:
                contentHeader()
                jobSelectionContent()
            case .startYear:
                contentHeader()
                startYearContent()
            case .register:
                registerContent()
            case .registerInfo:
                RegisterInfoContentView(store: store)
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
            ForEach(SignUp.JobOption.allCases, id: \.title) { option in
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
                action: { }
            ).disabled(true)
            
            if let startYear = viewStore.startYear {
                PrimaryButton(
                    title: String(startYear),
                    disabled: false,
                    type: .outline,
                    action: { }
                ).disabled(true)
            } else {
                AccessoryButton(
                    title: "근무 시작년도를 선택해주세요",
                    action: { viewStore.send(.showSelectYearSheet) }
                )
            }
        }
    }
    
    @ViewBuilder func registerContent() -> some View {
        VStack(spacing: 20) {
            Image("character", bundle: .main)
            Text(viewStore.selectedJob!.title + "로 설정완료")
                .fontModifer(.h6)
                .foregroundStyle(Color.colors(.black))
            Text("가입완료까지 거의다 왔어요!")
                .foregroundStyle(Color.colors(.gray07))
                .fontModifer(.sb1)
                .offset(y: -12)
        }.padding(.top, 132)
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
                    viewStore.send(
                        .setStage(.register),
                        animation: .default)
                }
            ).padding(.bottom, 70)
        case .register:
            VStack(spacing: 10) {
                ForEach(LoginMethod.allCases, id: \.self) { method in
                    switch method {
                    case .kakao, .apple:
                        CustomButton(
                            leadingIcon: method.icon!,
                            title: method.buttonTitle,
                            foreground: method.foreground,
                            background: method.background,
                            action: { viewStore.send(.didSelectLoginMethod(method)) }
                        )
                    case .email:
                        Button(action: {
                            viewStore.send(.didSelectLoginMethod(method))
                        }, label: {
                            Text("이메일로 시작하기")
                                .fontModifer(.sb2)
                                .foregroundStyle(method.foreground)
                        })
                    }
                }
            }.padding(.bottom, 38)
        case .registerInfo:
            PrimaryButton(
                title: "가입완료",
                disabled: !viewStore.hasAllow,
                action: { }
            ).hide(when: viewStore.focusState != .none)
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
            onFinish: { }
        ).presentationDetents([.height(488)])
    }
    
    @ViewBuilder func selectTelecomSheet() -> some View {
        SelectTelecomView(
            isPresented: viewStore.$showSelectTelecomSheet,
            selected: viewStore.$telecom
        ).presentationDetents([.height(460)])
    }
}

#Preview {
    SignUpView(store: .init(initialState: .init(), reducer: {
        SignUpView.Reducer(cooridonator: .init())
    }))
}
