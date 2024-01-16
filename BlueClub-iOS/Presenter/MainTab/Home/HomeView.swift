//
//  HomeView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/12/24.
//

import SwiftUI
import DesignSystem

struct HomeView: View {
    
    @State var tooltipWidth: CGFloat = .zero
    @State var progressWidth: CGFloat = .zero
    let progress: CGFloat = 0.2
    
    @State var currentPage = 1
    @State var indicatorPage = 1
    @Namespace var animation
    
    var body: some View {
        BaseView {
            AppBar(trailingIcons: [
                (Icons.calendar_large, { }),
                (Icons.notification1_large, { })
            ])
        } content: {
            content()
        }.background(Color.colors(.cg02))
    }
}

extension HomeView {
    
    @ViewBuilder func contentHeader() -> some View {
        HStack(spacing: 8) {
            Text("골프캐디")
                .fontModifer(.h5)
                .foregroundStyle(Color.black)
            HStack(spacing: 4) {
                Image(.dot)
                Text("3년째 근무증")
                    .fontModifer(.b3)
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
                contentBody()
                    .padding(.bottom, 39)
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
        VStack(spacing: 12) {
            incomeInfoHeader()
            incomeIndicator()
            CustomDivider()
            incomeInfoFooter()
        }
        .padding(20)
        .roundedBackground()
        .roundedBorder()
    }
    
    @ViewBuilder func incomeInfoHeader() -> some View {
        HStack(spacing: 8) {
            Text("달성 수입")
                .fontModifer(.sb3)
                .foregroundStyle(Color.colors(.primaryNormal))
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .roundedBackground(.colors(.primaryBackground), radius: 4)
            let amount = 400000
            Group {
                Text("\(amount)") + Text("원")
            }
            .fontModifer(.h6)
            .foregroundStyle(Color.colors(.cg10))
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
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(1...10, id: \.self) { count in
                    contentCell(index: count)
                }
            }.padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder func contentCell(index: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            let image: ImageResource = index / 2 == 0 
                ? .contentCharacter1
                : .contentCharacter2
            let text = index / 2 == 0
                ? "자산을 더하는 수입관리 금융상품"
                : "프리랜서들을 위한 연말정산 가이드"
            Image(image)
            Text(text)
                .fontModifer(.sb2)
                .foregroundStyle(Color.colors(.gray08))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .square(148)
        .roundedBackground()
        .roundedBorder()
    }
}

fileprivate struct PercentToolTipView: View {
    
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

#Preview {
    MainTabView(state: .init())
}
