//
//  ScheduleNoteView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/13/24.
//

import SwiftUI
import DesignSystem
import Domain

struct ScheduleNoteView: View {
    
    @StateObject var viewModel: ScheduleNoteViewModel
    
    init(viewModel: ScheduleNoteViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    @State var progressWidth: CGFloat = .zero
    @State var tooltipWidth: CGFloat = .zero
    @GestureState var calendarDrag: CGFloat = .zero

    let calendarColumns: [GridItem] = Array(
        repeating: .init(),
        count: 7)
    
    var body: some View {
        BaseView {
            TitleBar(
                title: "근무수첩",
                trailingIcons: [
                    (Icons.setting_solid, { 
                        viewModel.send(.didTapGearIcon)
                    }),
                    (Icons.notification1_large, { 
                        viewModel.coordinator?.send(.notice)
                    })
                ])
        } content: {
            content()
        }
        .background(Color.colors(.cg01))
        .onAppear {
            viewModel.send(.fetchGoal)
            viewModel.send(.fetchDiaryList)
        }
        .disabled(viewModel.isLoading)
        .loadingSpinner(viewModel.isLoading)
    }
}

// MARK: - SubView
extension ScheduleNoteView {
    @ViewBuilder func content() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                contentHeader()
                calendarView()
                Group {
                    diaryListHeader()
                    diaryList()
                }.background(Color.white)
            }
        }.overlay(alignment: .bottomTrailing) {
            Button(action: {
                viewModel.send(.scheduleEdit)
            }, label: {
                Image(.floatingButton)
            }).padding(20)
        }
    }
    
    @ViewBuilder func calendarView() -> some View {
        VStack(spacing: 0) {
            calendarHeader()
            calendarContent()
                .padding(.vertical, 6)
                .offset(x: calendarDrag)
                .highPriorityGesture(
                    DragGesture(minimumDistance: 4).onEnded({ value in
                        let dragY = value.translation.width
                        if dragY > 0 {
                            viewModel.send(.decreaseMonth)
                        } else {
                            viewModel.send(.increaseMonth)
                        }
                    }).updating($calendarDrag, body: { value, state, transaction in
                        state = value.translation.width
                    })
                )
        }
        .padding(.horizontal, 25)
    }
    
    @ViewBuilder func contentHeader() -> some View {
        VStack(spacing: 16) {
            
            // 달성 수입
            HStack(spacing: 8) {
                ChipView("달성 수입")
                Group {
                    Text("\(viewModel.goal?.totalIncome ?? 0)")
                    + Text("원")
                }
                .fontModifer(.h7)
                .foregroundStyle(Color.colors(.cg10))
                .if(viewModel.goal == nil) {
                    $0.redacted(reason: .placeholder)
                }
                
                Spacer()
                Button(action: {
                    viewModel.send(.toggleHasExpand)
                }, label: {
                    let degree: Double = viewModel.hasExpand ? 180 : 0
                    Image.icons(.arrow_bottom)
                        .foregroundStyle(Color.colors(.gray06))
                        .rotationEffect(.degrees(degree))
                })
            }
            
            if viewModel.hasExpand {
                if let goal = viewModel.goal {
                    if viewModel.sholdReloadProgressBar {
                        headerProgressBar(goal)
                    } else {
                        headerProgressBar(goal)
                    }
                    CustomDivider(padding: 0)
                    // 나의 목표수입 설정
                    Button(action: {
                        viewModel.send(.didTapMonthlyGoalSetting)
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
        }
        .padding(16)
        .frame(minHeight: 56)
        .roundedBackground(radius: 12)
        .roundedBorder()
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
    }
    
    @ViewBuilder func headerProgressBar(_ goal: MonthlyGoalDTO) -> some View {
        // Progress
        VStack(spacing: 2) {
            Spacer(minLength: 0)
            CustomProgressBar(progress: goal.progorssFloat) {
                progressWidth = $0
            }
            Text(goal.targeIncomeLabel)
                .fontModifer(.caption2)
                .foregroundStyle(Color.colors(.cg05))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(height: 54)
        .overlay(alignment: .topLeading) {

            let offset = goal.progress == 0
                ? progressWidth - (tooltipWidth / 2) + 8
                : goal.progress == 100
                ? progressWidth - (tooltipWidth / 2) - 8
                : progressWidth - (tooltipWidth / 2)
            
            PercentToolTipView(progress: goal.progorssFloat)
                .getSize { self.tooltipWidth = $0.width }
                .padding(.bottom, 2)
                .offset(x: offset)
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Calendar SubView
extension ScheduleNoteView {
    
    @ViewBuilder func calendarHeader() -> some View {
        HStack(spacing: 4) {
            Button(action: {
                viewModel.send(.decreaseMonth)
            }, label: {
                Image(.polygonLeft)
                    .foregroundStyle(Color.colors(.gray06))
            })
            
            let year = viewModel.currentYear
            let month = viewModel.currentMonth
            
            Text("\(String(year))년 \(month)월")
                .fontModifer(.sb2)
                .foregroundStyle(Color.colors(.gray08))
                .frame(width: 100)
            
            Button(action: {
                viewModel.send(.increaseMonth)
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
            ForEach(viewModel.days, id: \.?.day) { day in
                let diary: DiaryListDTO.MonthlyRecord? = viewModel.diaryList.first {
                    $0.date == day?.combinedDateString
                }
                Button {
                    if let diary {
                        viewModel.send(.scheduleEditById(diary.id))
                    } else if diary == nil, let day {
                        viewModel.send(.scheduleEditByDate(day.combinedDateString))
                    }
                } label: {
                    calendarCell(day, diary: diary)
                }
            }
        }
    }
    
    @ViewBuilder func calendarCell(_ day: Day?, diary: DiaryListDTO.MonthlyRecord?) -> some View {
        VStack(spacing: 4) {
            let isToday = viewModel.today.isSameDay(
                year: day?.year,
                month: day?.month,
                day: day?.day
            )
            if let day {
                Text(String(day.day))
                    .fontModifer(.sb2)
                    .foregroundStyle(
                        diary != nil
                        ? Color.colors(.white)
                        : isToday
                        ? Color.colors(.primaryNormal)
                        : Color.colors(.gray08))
                    .frame(height: 36)
                    .if(diary != nil) {
                        $0.background(
                            Image(.coin)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36))}
                    .if(diary == nil && isToday) {
                        $0.background(
                            Image(.todayBackground)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36))}
                Spacer(minLength: 0)
                if let diary {
                    Text(diary.incomeLabel)
                        .font(.pretendard(.medium, size: 9))
                        .foregroundStyle(Color.colors(.cg06))
                } else if isToday {
                    Text("Today")
                        .font(.pretendard(.medium, size: 9))
                        .foregroundStyle(Color.colors(.primaryNormal))
                }
            }
        }
        .frame(height: 50)
        .frame(width: 40)
    }
}

// MARK: - Diary SubView
extension ScheduleNoteView {
    
    @ViewBuilder func diaryListHeader() -> some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(viewModel.currentMonth)월 기록")
                .foregroundStyle(Color.colors(.gray10))
            if viewModel.diaryListCount != 0 {
                Text("\(viewModel.diaryListCount)")
                    .foregroundStyle(Color.colors(.primaryNormal))
            }
            Spacer()
        }
        .fontModifer(.sb1)
        .padding(.top, 24)
        .padding(.bottom, 16)
        .padding(.horizontal, 20)
        .frame(height: 62)
    }
    
    @ViewBuilder func diaryList() -> some View {
        if viewModel.diaryList.isEmpty && viewModel.monthIndex == 0 {
            Button {
                if viewModel.monthIndex == 0 {
                    viewModel.send(.scheduleEdit)
                } else {
                    let dateString = "\(viewModel.currentYear)-\(viewModel.currentMonth)-01"
                    viewModel.send(.scheduleEditByDate(dateString))
                }
            } label: {
                firstDiaryButton()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        } else if viewModel.diaryList.isEmpty && viewModel.monthIndex != 0 {
            emptyListButton()
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
        } else {
            ForEach(Array(viewModel.diaryList.enumerated()), id: \.element.id ) { offset, diary in
                Button {
                    viewModel.send(.scheduleEditById(diary.id))
                } label: {
                    DiaryListCell(diary: diary)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
                .if(offset == viewModel.diaryListCount - 1) {
                    $0.padding(.bottom, 38)
                }
            }
        }
    }
    
    @ViewBuilder func firstDiaryButton() -> some View {
        HStack {
            Text("\(viewModel.currentMonth)월의 첫 근무기록 남기러 가기")
                .fontModifer(.sb2)
            Spacer()
            Image.icons(.arrow_right)
                .resizable()
                .scaledToFit()
                .frame(width: 20)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .frame(height: 60)
        .roundedBorder(Color.colors(.primaryNormal))
    }
    
    @ViewBuilder func emptyListButton() -> some View {
        HStack {
            Text("작성된 근무기록이 없습니다.")
                .fontModifer(.sb2)
                .foregroundStyle(Color.colors(.gray05))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .frame(height: 60)
        .roundedBorder()
    }
}

#Preview {
    ScheduleNoteView(
        viewModel: .init(
            coordinator: .init(
                navigator: .init())
            ,dependencies: .live)
        )
}
