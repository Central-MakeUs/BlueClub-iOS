//
//  AnnouncementView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/9/24.
//

import SwiftUI
import DesignSystem
import Architecture

struct AnnouncementView: View {
    
    @State var hasAllow = false
    @State var isEmpty = true
    
    weak var coordinator: MyPageCoordinator?
    
    var body: some View {
        BaseView {
            AppBar(
                leadingIcon: (Icons.arrow_left, {
                    coordinator?.pop()
                }),
                title: "공지사항")
        } content: {
            Group {
                if isEmpty {
                    emptyPlaceholder()
                } else {
                    listView()
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity)
            .background(Color.colors(.gray01))
        }
    }
    
    @ViewBuilder func listView() -> some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach((1..<20)) { _ in
                    Button(action: {
                        Task {
                            await coordinator?.send(.announcementDetail)
                        }
                    }, label: {
                        listCell()
                    })
                }
            }
            .padding(20)
        }
    }
    
    @ViewBuilder func listCell() -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(.myPageIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Text("공지내용입니다. 공지내용 입니다아.")
                    .fontModifer(.sb1)
                    .foregroundStyle(Color.colors(.black))
                Spacer()
                Image(.newBadge)
                    .padding(.trailing, 6)
            }
            .frame(height: 24)
            VStack(alignment: .leading, spacing: 8) {
                Text("본문내용입니다. 본문내용입니다.본문내용입니다.본문내용입니다.본문내용입니다.")
                    .fontModifer(.b2)
                    .foregroundStyle(Color.colors(.gray07))
                    .multilineTextAlignment(.leading)
                HStack {
                    Text("더보기")
                        .fontModifer(.caption1)
                        .foregroundStyle(Color.colors(.primaryNormal))
                        .frame(alignment: .leading)
                    Spacer()
                    Text("23.12.08")
                        .fontModifer(.caption1)
                        .foregroundStyle(Color.colors(.gray06))
                }
            }.padding(.leading, 32)
        }
        .padding(20)
        .roundedBackground()
        .roundedBorder()
    }
    
    @ViewBuilder func emptyPlaceholder() -> some View {
        VStack(spacing: 20) {
            Image(.errorCoin)
            VStack(spacing: 8) {
                Text("아직 게시된 공지글이 없어요")
                    .fontModifer(.h6)
                    .foregroundStyle(Color.colors(.black))
                if hasAllow {
                    Text("새로운 소식이 생기면\n푸시 알림으로 가장 먼저 알려 드릴게요!")
                        .fontModifer(.sb2)
                        .foregroundStyle(Color.colors(.gray07))
                        .multilineTextAlignment(.center)
                } else {
                    Text("푸시 알림에 동의해 주시면\n새로운 소식을 가장 먼저 알려 드릴게요!")
                        .fontModifer(.sb2)
                        .foregroundStyle(Color.colors(.gray07))
                        .multilineTextAlignment(.center)
                }
            }
            if !hasAllow {
                CustomButton(
                    title: "알림 설정하러 가기",
                    foreground: .colors(.white),
                    background: .colors(.primaryNormal),
                    action: {
                        hasAllow = true
                        isEmpty = false
                    }
                ).padding(.horizontal, 55)
            }
            Spacer()
        }.padding(.top, 138)
    }
}

#Preview {
    AnnouncementView()
}
