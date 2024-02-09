//
//  MyPageView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/1/24.
//

import SwiftUI
import DesignSystem
import Domain

struct MyPageView: View {
    
    @StateObject var viewModel: MyPageViewModel
    var user: AuthDTO? { viewModel.user }
    
    init(viewModel: MyPageViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        BaseView {
            TitleBar(
                title: "마이페이지",
                trailingIcons: [
                    (Icons.notification1_large, { 
                        viewModel.send(.notification)
                    })
                ]
            )
        } content: {
            ScrollView {
                LazyVStack {
                    header()
                    ForEach(MyPageItemRow.allCases, id: \.self) { row in
                        rowCell(row)
                    }
                    footer()
                }
            }
        }
        .background(Color.colors(.cg01))
    }
}

private extension MyPageView {
    
    @ViewBuilder func header() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Image(.myPageIcon)
                VStack(alignment: .leading, spacing: 2) {
                    Button(action: {
                        viewModel.send(.profileEdit)
                    }, label: {
                        HStack(spacing: 4) {
                            Text(user?.job ?? "")
                                .fontModifer(.h7)
                                .foregroundStyle(Color.colors(.black))
                            Image.icons(.arrow_right)
                                .foregroundStyle(Color.colors(.gray08))
                        }
                    })
                    Text(user?.nickname ?? ""  + "님")
                        .fontModifer(.sb2)
                        .foregroundStyle(Color.colors(.cg06))
                    Spacer(minLength: 0)
                    ChipView("목표수입 \(viewModel.monthlyTarget)만원")
                }
                Spacer()
            }
            .frame(height: 74)
            .padding(20)
            LazyVGrid(columns: Array(repeating: .init(), count: 3), spacing: 16) {
                ForEach(MyPageHeaderButton.allCases, id: \.self) { button in
                    Button {
                        
                    } label: {
                        headerBottomButton(button)
                    }
                }
            }
            .padding(.horizontal, 16)
            .overlay(alignment: .top) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.colors(.cg01))
                    .padding(.horizontal, 20)
            }
        }
        .roundedBorder()
        .background(Color.white)
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
    
    @ViewBuilder func headerBottomButton(_ button: MyPageHeaderButton) -> some View {
        VStack(spacing: 4) {
            button.image
            Text(button.title)
                .fontModifer(.sb3)
                .foregroundStyle(Color.colors(.cg06))
        }
        .frame(width: 80, height: 82)
    }
    
    @ViewBuilder func rowCell(_ row: MyPageItemRow) -> some View {
        if row == .versionInfo {
            HStack {
                HStack(alignment: .bottom, spacing: 8) {
                    Text(row.title)
                        .fontModifer(.b1m)
                        .foregroundStyle(Color.colors(.black))
                    Text(viewModel.appVersion)
                        .fontModifer(.b2m)
                        .foregroundStyle(Color.colors(.gray05))
                }.frame(height: 24)
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("업데이트")
                        .foregroundStyle(Color.white)
                        .fontModifer(.sb3)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .roundedBackground(
                            Color.colors(.black),
                            radius: 4
                        )
                })
            }
            .frame(height: 52)
            .padding(.horizontal, 30)
        } else {
            Button(action: {
                viewModel.send(.didTapListItem(row))
            }, label: {
                HStack {
                    Text(row.title)
                        .fontModifer(.b1m)
                        .foregroundStyle(Color.colors(.black))
                    Spacer()
                    Image.icons(.arrow_right)
                        .foregroundStyle(Color.colors(.gray05))
                }
                .frame(height: 52)
                .padding(.horizontal, 30)
            })
        }
    }
    
    @ViewBuilder func footer() -> some View {
        VStack(spacing: 16) {
            Button {
                
            } label: {
                HStack(spacing: 4) {
                    Image.icons(.kakao)
                    Text("블루클럽 카카오 채널 문의")
                        .fontModifer(.sb2)
                        .foregroundStyle(Color(hex: "3C1E1E"))
                }
                .frame(height: 52)
                .frame(maxWidth: .infinity)
                .roundedBackground(.init(hex: "FDE500"))
            }
            Text("궁금한 점이 있으면 언제든 문의해 주세요 🤔")
                .fontModifer(.b2)
                .foregroundStyle(Color.colors(.black))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
}

enum MyPageHeaderButton: CaseIterable {
    
    case friend
    case ask
    case service
    
    var image: Image {
        switch self {
        case .friend:
            return .init(.userPlus)
        case .ask:
            return .init(.envelope)
        case .service:
            return .init(.commentSquare)
        }
    }
    
    var title: String {
        switch self {
        case .friend:
            return "친구 초대"
        case .ask:
            return "문의하기"
        case .service:
            return "서비스 의견함"
        }
    }
}

enum MyPageItemRow: CaseIterable {
    case announcement
    case notificationSetting
    case termsOf
    case privacy
    case versionInfo
    
    var title: String {
        switch self {
        case .announcement:
            return "공지사항"
        case .notificationSetting:
            return "알림 설정"
        case .termsOf:
            return "이용약관"
        case .privacy:
            return "개인정보 처리방침"
        case .versionInfo:
            return "버전정보"
        }
    }
}

#Preview {
    MyPageView(
        viewModel: .init(
            coordinator: .init(
                navigator: .init())))
}
