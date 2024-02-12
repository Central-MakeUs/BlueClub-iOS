//
//  AnnouncementDetailView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/9/24.
//

import SwiftUI
import DesignSystem
import Architecture
import Domain
import Navigator

struct NoticeDetailView: View {
    
    weak var navigator: Navigator?
    private let notice: NoticeDTO
    
    init(navigator: Navigator? = nil, notice: NoticeDTO) {
        self.navigator = navigator
        self.notice = notice
    }
    
    var body: some View {
        BaseView {
            AppBar(
                leadingIcon: (Icons.arrow_left, {
                    navigator?.pop()
                }),
                title: "공지사항")
        } content: {
            ScrollView {
                VStack(spacing: 0) {
                    header()
                    CustomDivider(padding: 0)
                        .padding(.horizontal, 20)
                    content()
                }
            }
        }
    }
    
    @ViewBuilder func header() -> some View {
        VStack(spacing: 8) {
            Text(notice.title)
                .lineLimit(.max)
                .fontModifer(.h7)
                .foregroundStyle(Color.colors(.gray10))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text(notice.dateString)
                .fontModifer(.b3)
                .foregroundStyle(Color.colors(.gray06))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
    }
    
    @ViewBuilder func content() -> some View {
        Text(notice.content)
            .lineLimit(.max)
            .fontModifer(.b1)
            .foregroundStyle(Color.colors(.gray09))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
    }
}
