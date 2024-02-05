//
//  HomeView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/12/24.
//

import SwiftUI
import DesignSystem
import Lottie

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    init(coordinator: HomeCoordinator) {
        let viewModel = HomeViewModel(coodinator: coordinator)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    @State var tooltipWidth: CGFloat = .zero
    @State var progressWidth: CGFloat = .zero
    let progress: CGFloat = 0.2
    
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
        }.background(Color.colors(.cg02))
    }
}

extension HomeView {
    
    @ViewBuilder func contentHeader() -> some View {
        HStack(spacing: 8) {
            Text(viewModel.job.title)
                .fontModifer(.h5)
                .foregroundStyle(Color.black)
            HStack(spacing: 4) {
                Image(.dot)
                Text("\(viewModel.name)님")
                    .fontModifer(.sb2)
                    .foregroundStyle(Color.colors(.gray08))
            }
            Spacer()
        }
        .frame(height: 66)
        .padding(.horizontal, 30)
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
            Image(.coin)
            Text("28일 연속 코인 획득중이에요")
                .fontModifer(.sb2)
                .foregroundStyle(Color.colors(.gray09))
            Text("기록갱신")
                .fontModifer(.caption3)
                .foregroundStyle(Color.colors(.cg06))
                .frame(height: 14)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .roundedBackground(.colors(.cg02), radius: 4)
                .padding(.leading, -8)
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 62)
        .roundedBackground()
        .roundedBorder()
    }
    
    @ViewBuilder func incomeInfoView() -> some View {
        VStack(spacing: 16) {
            incomeInfoHeader()
            if viewModel.달성수입 != .none {
                incomeIndicator()
            } else {
                LottieView(animation: .named("progress"))
                    .playing(loopMode: .loop)
                    .frame(maxWidth: .infinity)
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
            if let 달성수입 = viewModel.달성수입 {
                Group {
                    Text("\(달성수입)") + Text("원")
                }
                .fontModifer(.h7)
                .foregroundStyle(Color.colors(.cg10))
            } else {
                Text("수입을 기록해봐요")
                    .fontModifer(.h7)
                    .foregroundStyle(Color.colors(.cg04))
            }
            Spacer()
        }.frame(height: 28)
    }
    
    @ViewBuilder func incomeIndicator() -> some View {
        VStack(spacing: 2) {
            Spacer(minLength: 0)
            CustomProgressBar(progress: progress) { progressWidth = $0 }
            Text("1000만원")
                .fontModifer(.caption2)
                .foregroundStyle(Color.colors(.cg05))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(height: 54)
        .overlay(alignment: .topLeading) {
            PercentToolTipView(percent: progress)
                .getSize { self.tooltipWidth = $0.width }
                .padding(.bottom, 2)
                .offset(x: progressWidth - (tooltipWidth / 2))
        }
    }
    
    @ViewBuilder func incomeInfoFooter() -> some View {
        Button(action: {
            
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
}

struct PercentToolTipView: View {
    
    let percent: CGFloat
    var percentString: String {
        String(Int(percent * 100))
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
