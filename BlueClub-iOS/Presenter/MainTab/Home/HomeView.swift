//
//  HomeView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/12/24.
//

import SwiftUI
import DesignSystem
import Lottie
import Domain

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    init(coordinator: HomeCoordinator) {
        let viewModel = HomeViewModel(coodinator: coordinator)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    @State var tooltipWidth: CGFloat = .zero
    @State var progressWidth: CGFloat = .zero
    
    @State var currentPage = 1
    @State var indicatorPage = 1
    @Namespace var animation
    
    var body: some View {
        BaseView {
            TitleBar(trailingIcons: [
                (Icons.notification1_large, { 
                    viewModel.coodinator?.send(.notification)
                })
            ])
        } content: {
            content()
        }
        .background(Color.colors(.cg02))
        .onAppear { viewModel.send(.fetchData) }
    }
}

extension HomeView {
    
    @ViewBuilder func contentHeader() -> some View {
        HStack(spacing: 8) {
            Text(viewModel.user?.job ?? "       ")
                .fontModifer(.h5)
                .foregroundStyle(Color.black)
            HStack(spacing: 4) {
                Image(.dot)
                Text("\(viewModel.user?.nickname ?? "     ")님")
                    .fontModifer(.sb2)
                    .foregroundStyle(Color.colors(.gray08))
            }
            Spacer()
        }
        .frame(height: 66)
        .padding(.horizontal, 30)
        .if(viewModel.user == nil) {
            $0.redacted(reason: .placeholder)
        }
    }
    
    @ViewBuilder func content() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                contentHeader()
                contentBody().padding(.bottom, 24)
                contentFooter()
            }
        }
    }
    
    @ViewBuilder func contentBody() -> some View {
        VStack(spacing: 12) {
            rotateBanner()
            dayInfoView()
            incomeInfoView()
        }.padding(.horizontal, 20)
    }
    
    @ViewBuilder func rotateBanner() -> some View {
        TabView(selection: $currentPage) {
            ForEach(1...3, id: \.self) { page in
                Color.colors(.primaryNormal)
                    .tag(page)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 96)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(alignment: .topLeading) {
            bannerIndicator()
        }
    }
    
    @ViewBuilder func bannerIndicator() -> some View {
        HStack(spacing: 4) {
            ForEach(1...3, id: \.self) { page in
                if indicatorPage == page {
                    RoundedRectangle(cornerRadius: 21)
                        .foregroundStyle(Color.white)
                        .frame(width: 12)
                        .matchedGeometryEffect(id: "indicator", in: animation)
                } else {
                    Circle()
                        .frame(width: 4)
                        .foregroundStyle(Color.colors(.white).opacity(0.5))
                }
            }
        }
        .frame(height: 4)
        .padding(.leading, 20)
        .padding(.top, 18)
        .syncState($currentPage, sync: $indicatorPage)
    }
    
    @ViewBuilder func dayInfoView() -> some View {
        HStack(spacing: 16) {
            if let record = viewModel.record, 
               let month = viewModel.currentMonth,
               let user = viewModel.user {
                if record.totalIncome == 0 {
                    Image(.faceCoin)
                    Text("\(month)월 \(user.nickname)님의 첫 기록이 기다려져요!")
                        .fontModifer(.sb2)
                        .foregroundStyle(Color.colors(.gray09))
                        .lineLimit(2)
                    Spacer()
                } else if record.totalDay == 1, record.straightDay == 1 {
                    Image(.coin)
                        .overlay(alignment: .topTrailing) {
                            coinTrailingLabel(record.totalDay)
                        }
                    Text("\(user.nickname)님 이번달 시작이 좋아요!")
                        .fontModifer(.sb2)
                        .foregroundStyle(Color.colors(.gray09))
                        .lineLimit(2)
                    Spacer()
                    ChipView("NEW", style: .red)
                } else if record.totalDay > 0, record.straightDay == 0 {
                    Image(.emptyCoin)
                        .overlay(alignment: .topTrailing) {
                            coinTrailingLabel(record.totalDay)
                        }
                    Text("\(user.nickname)님 깜빡하신 근무기록은 없으신가요?")
                        .fontModifer(.sb2)
                        .foregroundStyle(Color.colors(.gray09))
                        .lineLimit(2)
                    Spacer()
                } else if record.isRenew {
                    Image(.coin)
                        .overlay(alignment: .topTrailing) {
                            coinTrailingLabel(record.totalDay)
                        }
                    Text("\(record.straightDay)일 연속 코인 획득중이에요")
                        .fontModifer(.sb2)
                        .foregroundStyle(Color.colors(.gray09))
                        .lineLimit(2)
                    Spacer()
                    ChipView("기록갱신", style: .red)
                } else if record.straightMonth > 1 {
                    Image(.coin)
                        .overlay(alignment: .topTrailing) {
                            coinTrailingLabel(record.totalDay)
                        }
                    Text("\(record.straightDay)일 연속 코인 획득중이에요")
                        .fontModifer(.sb2)
                        .foregroundStyle(Color.colors(.gray09))
                        .lineLimit(2)
                    Spacer()
                    ChipView("\(record.straightMonth)달연속", style: .red)
                }
            } else {
                Image(.emptyCoin)
                Text("           ")
                    .fontModifer(.sb2)
                    .foregroundStyle(Color.colors(.gray09))
                    .redacted(reason: .placeholder)
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 62)
        .roundedBackground()
        .roundedBorder()
    }
    
    @ViewBuilder func incomeInfoView() -> some View {
        VStack(spacing: 16) {
            incomeInfoHeader()
            if viewModel.shouldReloadProgressBar {
                incomeIndicator(viewModel.record)
            } else {
                incomeIndicator(viewModel.record)
            }
            CustomDivider(padding: 0)
            incomeInfoFooter()
        }
        .padding(20)
        .roundedBackground()
        .roundedBorder()
    }
    
    @ViewBuilder func incomeInfoHeader() -> some View {
        HStack(spacing: 8) {
            ChipView("달성 수입")
            Group {
                if let totalIncome = viewModel.record?.totalIncome, totalIncome > 0 {
                    Text("\(totalIncome.withComma())") + Text("원")
                        .foregroundColor(.colors(.cg10))
                } else {
                    Text("수입을 기록해봐요")
                        .foregroundStyle(Color.colors(.cg04))
                }
            }.fontModifer(.h7)
            Spacer()
        }.frame(height: 28)
    }
    
    @ViewBuilder func incomeIndicator(_ record: DiaryRecordDTO?) -> some View {
        VStack(spacing: 2) {
            Spacer(minLength: 0)
            CustomProgressBar(progress: record?.progorssFloat ?? 0) {
                progressWidth = $0
            }
            Text(record?.targetIncomLabel ?? "0만원")
                .fontModifer(.caption2)
                .foregroundStyle(Color.colors(.cg05))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(height: 54)
        .overlay(alignment: .topLeading) {
            let offset = record?.progress == 0
                ? progressWidth - (tooltipWidth / 2) + 7
                : progressWidth - (tooltipWidth / 2)
            PercentToolTipView(progress: record?.progorssFloat ?? 0.0)
                .getSize { self.tooltipWidth = $0.width }
                .padding(.bottom, 2)
                .offset(x: offset)
        }
    }
    
    @ViewBuilder func incomeInfoFooter() -> some View {
        Button(action: {
            viewModel.coodinator?.send(.scheduleNoteEdit)
        }, label: {
            HStack(spacing: 4) {
                Text("근무 기록하고 달성률 채우러 가기")
                Image.icons(.arrow_right)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16)
            }
            .fontModifer(.b2)
            .foregroundStyle(Color.colors(.cg06))
        })
    }
    
    @ViewBuilder func contentFooter() -> some View {
        LazyVGrid(columns: Array(repeating: .init(), count: 2), spacing: 10, content: {
            ForEach(HomeFooterContent.allCases, id: \.self) { content in
                Button(action: {
                    
                }, label: {
                    contentCell(content: content)
                }).disabled(true)
            }
        }).padding(.horizontal, 20)
    }
    
    @ViewBuilder func contentCell(content: HomeFooterContent) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            content.image
            Text(content.title)
                .fontModifer(.sb3)
                .foregroundStyle(Color.colors(.gray06))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(content.description)
                .fontModifer(.sb1)
                .foregroundStyle(Color.colors(.gray09))
        }
        .overlay(alignment: .topTrailing) {
            if !content.hasOpen {
                Text("오픈 예정")
                    .fontModifer(.caption3)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .roundedBackground(
                        .colors(.primaryNormal),
                        radius: 25)
            }
        }
        .padding(16)
        .frame(height: 116)
        .roundedBackground()
        .roundedBorder()
    }
    
    @ViewBuilder func coinTrailingLabel(_ int: Int) -> some View {
        Text(String(int))
            .fontModifer(.caption3)
            .foregroundStyle(Color.colors(.white))
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .roundedBackground(.colors(.cg07))
    }
}

struct PercentToolTipView: View {
    
    let progress: CGFloat
    var percentString: String {
        String(Int(progress * 100))
    }
    var body: some View {
        Text(percentString + "%")
            .fontModifer(.caption3)
            .foregroundStyle(Color.white)
            .padding(.vertical, 2)
            .padding(.horizontal, 10)
            .roundedBackground(.colors(.cg07))
            .overlay(alignment: .bottom) {
                Image(.tooltipEnd)
                    .offset(y: 4)
                    .foregroundStyle(Color.colors(.cg07))
            }
    }
}

enum HomeFooterContent: CaseIterable {
    case incomeReportCollection, infoCollection
    
    var image: Image {
        switch self {
        case .incomeReportCollection:
            return Image(.communityChat)
        case .infoCollection:
            return Image(.infoCollection)
        }
    }
    
    var title: String {
        switch self {
        case .incomeReportCollection:
            return "같은 직군끼리"
        case .infoCollection:
            return "블로버를 위한"
        }
    }
    
    var description: String {
        switch self {
        case .incomeReportCollection:
            return "정보교류 커뮤니티"
        case .infoCollection:
            return "근로 정보 모음집"
        }
    }
    
    var hasOpen: Bool {
        return false
    }
}
#Preview {
    MainTabView(navigator: .init())
}
