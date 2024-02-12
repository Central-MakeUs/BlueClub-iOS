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
                        viewModel.coordinator?.send(.notification)
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
    }
}

extension ScheduleNoteView {
    @ViewBuilder func content() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                contentHeader()
                calendarView()
                diaryListHeader()
                diaryList()
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
                ? progressWidth - (tooltipWidth / 2) + 7
                : progressWidth - (tooltipWidth / 2)
            
            PercentToolTipView(progress: goal.progorssFloat)
                .getSize { self.tooltipWidth = $0.width }
                .padding(.bottom, 2)
                .offset(x: offset)
        }
        .padding(.horizontal, 4)
    }
    
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
            // calendarBody
            
            ForEach(viewModel.days, id: \.?.day) { day in
                let diary: DiaryListDTO.MonthlyRecord? = viewModel.diaryList.first {
                    $0.date == day?.combinedDateString
                }
                Button {
                    if let diary {
                        viewModel.send(.scheduleEditById(diary.id))
                    } else if diary == nil, let day {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                        let date = dateFormatter.date(from: day.combinedDateString)
                        guard let date else { return }
                        viewModel.send(.scheduleEditByDate(date))
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
        .frame(height: 22)
        .padding(.top, 24)
        .padding(.horizontal, 20)
        .frame(height: 62)
    }
    
    @ViewBuilder func diaryList() -> some View {
        if viewModel.diaryList.isEmpty {
            Button {
                viewModel.send(.scheduleEdit)
            } label: {
                firstDiaryButton()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        } else {
            ForEach(viewModel.diaryList) { diary in
                Button {
                    
                } label: {
                    DiaryListCell(diary: diary)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
        }
    }
    
    @ViewBuilder func firstDiaryButton() -> some View {
        HStack {
            Text("\(viewModel.currentMonth)월의 첫 근무기록 남기러가기")
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
}

struct DiaryListCell: View {
    
    let diary: DiaryListDTO.MonthlyRecord
    
    var body: some View {
        HStack(spacing: 6) {
            Text(formatDateString(diary.date))
                .fontModifer(.sb2)
                .foregroundStyle(Color.colors(.gray07))
                .padding(.trailing, 4)
            switch diary.worktype {
            case "근무":
                ChipView("근무")
                infoView(
                    income: diary.income,
                    count: diary.cases)
            case "조퇴":
                ChipView("조퇴", style: .gray)
                infoView(
                    income: diary.income,
                    count: diary.cases)
            case "휴무":
                ChipView("휴무", style: .red)
                Text("오늘은 충전하는 날")
                    .fontModifer(.sb2)
                    .foregroundStyle(Color.colors(.gray05))
            default:
                EmptyView()
            }
            Spacer()
            Image.icons(.arrow_right)
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .foregroundStyle(Color.colors(.gray08))
        }
        .frame(height: 20)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .roundedBorder()
    }
    
    @ViewBuilder func infoView(income: Int, count: Int?) -> some View {
        HStack(spacing: 2) {
            Text("\(income)")
            if let count {
                Text("·")
                Text("\(count)건")
            }
        }
        .fontModifer(.sb2)
        .foregroundStyle(Color.colors(.gray10))
    }
    
    func formatDateString(_ input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: input) else { return "" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "dd.MM '월'"
        
        let output = outputFormatter.string(from: date)
        return output
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
