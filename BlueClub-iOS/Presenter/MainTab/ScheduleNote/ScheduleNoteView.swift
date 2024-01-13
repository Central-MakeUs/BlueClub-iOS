//
//  ScheduleNoteView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/13/24.
//

import SwiftUI
import DesignSystem

struct ScheduleNoteView: View {
    
    let amount = 100000000
    let progress: CGFloat = 0.8
    var percent: Int { Int(100 * progress) }
    var 만원단위: Int { Int(amount / 10000) }
    let calendarColumns: [GridItem] = Array(repeating: .init(), count: 7)
    
    var body: some View {
        BaseView {
            AppBar(
                title: "근무수첩",
                trailingIcons: [
                    (Icons.add_large, { }),
                    (Icons.notification1_large, { })
                ])
        } content: {
            content()
        }.background(Color.colors(.cg02))
    }
}

extension ScheduleNoteView {
    @ViewBuilder func content() -> some View {
        ScrollView {
            LazyVStack {
                contentHeader()
                calendarView()
            }
        }
    }
    
    @ViewBuilder func calendarView() -> some View {
        VStack(spacing: 0) {
            calendarHeader()
            calendarContent()
        }.padding(.horizontal, 23)
    }
    
    @ViewBuilder func contentHeader() -> some View {
        VStack(spacing: 10) {
            VStack(spacing: 0) {
                HStack(spacing: 4) {
                    Text("수입현황")
                        .foregroundStyle(Color.colors(.gray06))
                    Text("·")
                        .foregroundStyle(Color.colors(.gray06))
                    Text("15일 근무")
                        .foregroundStyle(Color.colors(.gray08))
                    Spacer()
                }.fontModifer(.sb2)
                HStack(spacing: 4) {
                    Text("\(amount)원")
                        .fontModifer(.h5)
                        .foregroundStyle(Color.colors(.cg10))
                    Text("\(percent)% 달성")
                        .fontModifer(.sb3)
                        .foregroundStyle(Color.colors(.primaryNormal))
                        .padding(.vertical, 3)
                        .padding(.horizontal, 6)
                        .roundedBackground(.colors(.primaryBackground))
                    Spacer()
                }
            }
            VStack(spacing: 4) {
                CustomProgressBar(progress: progress)
                Text(String(만원단위) + "만원")
                    .fontModifer(.caption2)
                    .foregroundStyle(Color.colors(.cg05))
                    .frame(maxWidth: .infinity , alignment: .trailing)
                    .padding(.trailing, 6)
            }
        }
        .padding(.top, 8)
        .frame(height: 118)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder func calendarHeader() -> some View {
        HStack(spacing: 10) {
            Button(action: {
                
            }, label: {
                Image.icons(.arrow_left)
            })
            Text("2024년 01월")
                .fontModifer(.b1m)
                .foregroundStyle(Color.colors(.gray08))
            Button(action: {
                
            }, label: {
                Image.icons(.arrow_right)
            })
        }
        .frame(height: 24)
        .padding(.vertical, 20)
    }
    
    @ViewBuilder func calendarContent() -> some View {
        LazyVGrid(columns: Array(repeating: .init(), count: 7)) {
            ForEach(WeekDay.allCases, id: \.self) { day in
                Text(day.title)
                    .fontModifer(.caption1)
                    .foregroundStyle(Color.colors(.gray07))
            }
        }
    }
}

enum WeekDay: CaseIterable {
    case sun, mon, tues, wed, thurs, fri, sat
    
    var title: String {
        switch self {
        case .sun:
            return "일"
        case .mon:
            return "월"
        case .tues:
            return "화"
        case .wed:
            return "수"
        case .thurs:
            return "목"
        case .fri:
            return "금"
        case .sat:
            return "토"
        }
    }
}

#Preview {
    ScheduleNoteView()
}
