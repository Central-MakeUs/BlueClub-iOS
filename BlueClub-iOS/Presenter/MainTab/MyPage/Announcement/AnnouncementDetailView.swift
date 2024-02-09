//
//  AnnouncementDetailView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/9/24.
//

import SwiftUI
import DesignSystem
import Architecture

struct AnnouncementDetailView: View {
    
    weak var coordinator: MyPageCoordinator?
    
    var body: some View {
        BaseView {
            AppBar(
                leadingIcon: (Icons.arrow_left, {
                    coordinator?.pop()
                }),
                title: "공지사항")
        } content: {
            ScrollView {
                VStack(spacing: 0) {
                    header()
                    content()
                }
            }
        }
    }
    
    @ViewBuilder func header() -> some View {
        VStack(spacing: 8) {
            Text("공지사항 내용입니다. 공지사항 내용입니다.공지사항 내용입니다.공지사항 내용입니다.")
                .lineLimit(.max)
                .fontModifer(.h7)
                .foregroundStyle(Color.colors(.gray10))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text("23.12.08")
                .fontModifer(.b3)
                .foregroundStyle(Color.colors(.gray06))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
    }
    
    @ViewBuilder func content() -> some View {
        Text("본문내용입니다. 본문내용입니다.본문내용입니다.본문내용입니다.본문내용입니다.본문내용입니다. 본문내용입니다.본문내용입니다.본문내용입니다.본문내용입니다.본문내용입니다. 본문내용입니다.본문내용입니다.본문내용입니다.본문내용입니다.")
            .lineLimit(.max)
            .fontModifer(.b1)
            .foregroundStyle(Color.colors(.gray09))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
    }
}

#Preview {
    AnnouncementDetailView()
}
