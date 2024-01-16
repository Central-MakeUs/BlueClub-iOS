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
                    (Icons.add_large, { }),
                    (Icons.notification1_large, { })
                ])
        } content: {
            content()
        }.onAppear { viewStore.send(.getDays) }
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
        }
        .padding(.horizontal, 23)
        .background(Color.colors(.cg01))
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
                    Text("\(viewStore.amount)원")
                        .fontModifer(.h5)
                        .foregroundStyle(Color.colors(.cg10))
                    Text("\(viewStore.percent)% 달성")
                        .fontModifer(.sb3)
                        .foregroundStyle(Color.colors(.primaryNormal))
                        .padding(.vertical, 3)
                        .padding(.horizontal, 6)
                        .roundedBackground(.colors(.primaryBackground))
                    Spacer()
                }
            }
            VStack(spacing: 4) {
                CustomProgressBar(progress: viewStore.progress)
                Text(String(viewStore.만원단위) + "만원")
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
                viewStore.send(.decreaseMonth)
            }, label: {
                Image.icons(.arrow_left)
                    .resizeWidth(16)
                    .foregroundStyle(Color.colors(.gray06))
            })
            if let year = viewStore.currentYear, let month = viewStore.currentMonth {
                Text("\(String(year))년 \(month)월")
                    .fontModifer(.b1m)
                    .foregroundStyle(Color.colors(.gray08))
            }
            Button(action: {
                viewStore.send(.increaseMonth)
            }, label: {
                Image.icons(.arrow_right)
                    .resizeWidth(16)
                    .foregroundStyle(Color.colors(.gray06))
            })
        }
        .frame(height: 24)
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
        }.padding(.bottom, 6)
        LazyVGrid(columns: Array(repeating: .init(), count: 7), spacing: 4) {
            // calendarBody
            ForEach(viewStore.days, id: \.?.day) { day in
                VStack(spacing: 0) {
                    Text(day != nil ? String(day!.day) : "")
                        .fontModifer(.sb2)
                        .foregroundStyle(Color.colors(.gray08))
                        .padding(.top, 10)
                        
                    Spacer(minLength: 0)
                }.frame(height: 52)
            }
        }
    }
}

#Preview {
    ScheduleNoteView(state: .init())
}
