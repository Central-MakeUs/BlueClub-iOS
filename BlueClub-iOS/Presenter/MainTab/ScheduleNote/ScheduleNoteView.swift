//
//  ScheduleNoteView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/13/24.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

struct ScheduleNoteView: View {
    
    typealias Reducer = ScheduleNote
    @ObservedObject var viewStore: ViewStoreOf<Reducer>
    
    let progress: CGFloat = 0.2
    @State var progressWidth: CGFloat = .zero
    @State var tooltipWidth: CGFloat = .zero
    
    init(state: Reducer.State) {
        let store: StoreOf<Reducer> = .init(
            initialState: state,
            reducer: { Reducer() })
        self.viewStore = .init(store, observe: { $0 })
    }

    let calendarColumns: [GridItem] = Array(repeating: .init(), count: 7)
    
    var body: some View {
        BaseView {
            AppBar(
                title: "근무수첩",
                trailingIcons: [
                    (Icons.setting_solid, { }),
                    (Icons.notification1_large, { })
                ])
        } content: {
            content()
        }
        .background(Color.colors(.cg01))
        .onAppear {
            viewStore.send(.getDays)
            viewStore.send(.getTdoay)
        }
    }
}

extension ScheduleNoteView {
    @ViewBuilder func content() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                contentHeader()
                calendarView()
                // 기록
                // 기록 리스트
            }
        }.overlay(alignment: .bottomTrailing) {
            Button(action: {
                
            }, label: {
                Image(.floatingButton)
            }).padding(20)
        }
    }
    
    @ViewBuilder func calendarView() -> some View {
        VStack(spacing: 0) {
            calendarHeader()
            calendarContent().padding(.vertical, 6)
        }
        .padding(.horizontal, 25)
    }
    
    @ViewBuilder func contentHeader() -> some View {
        VStack(spacing: 16) {
            
            // 달성 수입
            HStack(spacing: 8) {
                ChipView("달성 수입")
                Group {
                    Text("\(100000000)") + Text("원")
                }
                .fontModifer(.h7)
                .foregroundStyle(Color.colors(.cg10))
                Spacer()
                Button(action: {
                    viewStore.send(.toggleExpand, animation: .default)
                }, label: {
                    let degree: Double = viewStore.hasExpand ? 180 : 0
                    Image.icons(.arrow_bottom)
                        .foregroundStyle(Color.colors(.gray06))
                        .rotationEffect(.degrees(degree))
                })
            }
            
            if viewStore.hasExpand {
                // Progress
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
                CustomDivider(padding: 0)
                // 나의 목표수입 설정
                Button(action: {
                    
                }, label: {
                    HStack(spacing: 4) {
                        Text("나의 목표수입 설정")
                        Image.icons(.arrow_right)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16)
                    }
                    .fontModifer(.b2)
                    .foregroundStyle(Color.colors(.cg06))
                })
            }
        }
        .padding(16)
        .frame(minHeight: 56)
        .roundedBackground(radius: 12)
        .roundedBorder()
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
    }
    
    @ViewBuilder func calendarHeader() -> some View {
        HStack(spacing: 4) {
            Button(action: {
                viewStore.send(.decreaseMonth)
            }, label: {
                Image(.polygonLeft)
                    .foregroundStyle(Color.colors(.gray06))
            })
            if let year = viewStore.currentYear, let month = viewStore.currentMonth {
                Text("\(String(year))년 \(month)월")
                    .fontModifer(.sb2)
                    .foregroundStyle(Color.colors(.gray08))
                    .frame(width: 100)
            }
            Button(action: {
                viewStore.send(.increaseMonth)
            }, label: {
                Image(.polygonRight)
                    .foregroundStyle(Color.colors(.gray06))
            })
        }
        .frame(height: 64)
        .padding(.vertical, 20)
    }
    
    @ViewBuilder func calendarContent() -> some View {
        LazyVGrid(columns: Array(repeating: .init(), count: 7)) {
            // calendarHeader
            ForEach(WeekDay.allCases, id: \.self) { day in
                Text(day.title)
                    .fontModifer(.caption1)
                    .foregroundStyle(Color.colors(.gray07))
            }
        }
        .frame(height: 18)
        
        LazyVGrid(columns: Array(repeating: .init(), count: 7), spacing: 6) {
            // calendarBody
            ForEach(viewStore.days, id: \.?.day) { day in
                VStack(spacing: 4) {
                    
                    let isToday = viewStore.today?.isSameDay(
                        year: day?.year,
                        month: day?.month,
                        day: day?.day
                    ) ?? false
                    
                    Text(day != nil ? String(day!.day) : "")
                        .fontModifer(.sb2)
                        .foregroundStyle(
                            isToday
                            ? Color.colors(.primaryNormal)
                            : Color.colors(.gray08))
                        .frame(height: 36)
                        .if(isToday, {
                            $0.background(Image(.todayBackground))
                        })
                    
                    Spacer(minLength: 0)
                    if isToday {
                        Text("Today")
                            .font(.pretendard(.medium, size: 9))
                            .foregroundStyle(Color.colors(.primaryNormal))
                    }
                }
                .frame(height: 50)
                .frame(width: 40)
            }
        }
    }
}

#Preview {
    ScheduleNoteView(state: .init())
}
