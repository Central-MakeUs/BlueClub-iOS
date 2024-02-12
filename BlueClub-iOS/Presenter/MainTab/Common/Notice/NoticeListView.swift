//
//  AnnouncementView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/9/24.
//

import SwiftUI
import DesignSystem
import Architecture
import Navigator
import DependencyContainer
import Domain
import Utility

struct NoticeListView: View {
    
    @State var noticeList: [NoticeDTO] = []

    // MARK: - Dependencies
    private weak var navigator: Navigator?
    private let container: Container
    private var noticeApi: NoticeNetworkable { container.resolve() }
    
    init(
        navigator: Navigator,
        container: Container = .live
    ) {
        self.navigator = navigator
        self.container = container
    }
    
    var body: some View {
        BaseView {
            AppBar(
                leadingIcon: (Icons.arrow_left, {
                    navigator?.pop()
                }),
                title: "공지사항")
        } content: {
            Group {
                if noticeList.isEmpty {
                    emptyPlaceholder()
                } else {
                    listView()
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity)
            .background(Color.colors(.gray01))
        }.task {
            do {
                self.noticeList = try await noticeApi.getAll(lastId: nil)
            } catch {
                printError(error)
            }
        }
    }
    
    @ViewBuilder func listView() -> some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(self.noticeList) { notice in
                    Button(action: {
                        Task {
                            await navigator?.push {
                                NoticeDetailView(notice: notice)
                            }
                        }
                    }, label: {
                        listCell(notice)
                    })
                }
            }
            .padding(20)
        }
    }
    
    @ViewBuilder func listCell(_ notice: NoticeDTO) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(.myPageIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24)
                Text(notice.title)
                    .fontModifer(.sb1)
                    .foregroundStyle(Color.colors(.black))
                Spacer()
//                Image(.newBadge)
//                    .padding(.trailing, 6)
            }
            .frame(height: 24)
            VStack(alignment: .leading, spacing: 8) {
                Text(notice.content)
                    .fontModifer(.b2)
                    .foregroundStyle(Color.colors(.gray07))
                    .multilineTextAlignment(.leading)
                    .lineLimit(.max)
                HStack {
                    Spacer()
                    Text(notice.dateString)
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
                Text("새로운 소식이 생기면\n푸시 알림으로 가장 먼저 알려 드릴게요!")
                    .fontModifer(.sb2)
                    .foregroundStyle(Color.colors(.gray07))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }.padding(.top, 138)
    }
}

#Preview {
    NoticeListView(navigator: .init())
}
