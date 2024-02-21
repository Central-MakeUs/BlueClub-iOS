//
//  ScheduleEditView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/6/24.
//

import SwiftUI
import DesignSystem
import Architecture
import Combine
import DependencyContainer
import DataSource

struct ScheduleEditView: View {
    
    @StateObject var viewModel: ScheduleEditViewModel
    
    init(viewModel: ScheduleEditViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        BaseView {
            topBar()
        } content: {
            content()
        } footer: {
            bottomButton()
                .hide(when: viewModel.keyboardAppeared)
                .hide(when: viewModel.workType == .dayOff)
        }
        .onAppear {
            viewModel.send(.fetchUserInfo)
        }
        .loadingSpinner(viewModel.isLoading)
        .disabled(viewModel.isLoading)
        .sheet(isPresented: $viewModel.showScheduleTypeSheet) {
            ScheduleTypeSheet()
                .environmentObject(viewModel)
                .presentationDetents([.height(282)])
        }
        .sheet(isPresented: $viewModel.showMemoSheet, content: {
            MemoSheet(
                isPresented: $viewModel.showMemoSheet,
                text: $viewModel.memo)
        })
    }
}

extension ScheduleEditView {
    
    @ViewBuilder func topBar() -> some View {
        AppBar(
            leadingIcon: (Icons.arrow_left, {
                viewModel.coordinator?.pop()
            }),
            title: .none,
            isTrailingButtonActive: viewModel.isAvailable,
            trailingButton: ("저장", { 
                viewModel.send(.save)
            }))
    }
    
    @ViewBuilder func content() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                contentHeader()
                근무형태()
                if viewModel.workType != .dayOff {
                    switch viewModel.job {
                    case .caddy:
                        caddyContentRows()
                    case .rider:
                        riderContentRows()
                    case .dayWorker:
                        temporaryContentRows()
                    }
                    
                    Button(action: {
                        viewModel.showMemoSheet = true
                    }, label: {
                        memoPreview()
                    })
                    
                    plusButtons()
                    contentFooter()
                } else {
                    dayOffPlaceholder()
                }
            }
            .padding(.bottom, 120)
            .hideKeyboardOnTapBackground()
        }.scrollDismissesKeyboard(.immediately)
    }
    
    @ViewBuilder func dayOffPlaceholder() -> some View {
        VStack(spacing: 20) {
            Image(.coinSmile)
                .resizable()
                .scaledToFit()
                .frame(width: 98)
            VStack(spacing: 8) {
                Text("오늘 하루는 제대로 충전해요")
                    .fontModifer(.h6)
                    .foregroundStyle(Color.colors(.black))
                Text("휴무도 꾸준히 기록하는 습관\n너무 잘하고 있어요!")
                    .fontModifer(.sb2)
                    .foregroundStyle(Color.colors(.gray07))
                    .lineLimit(2)
            }
            .multilineTextAlignment(.center)
        }
        .padding(.top, 74)
    }
    
    @ViewBuilder func memoPreview() -> some View {
        if !viewModel.memo.isEmpty {
            VStack {
                HStack(spacing: 4) {
                    Image.icons(.file02)
                    Text("메모")
                        .fontModifer(.b1m)
                        .foregroundStyle(Color.colors(.cg06))
                    Spacer()
                }
                .frame(height: 24)
                Text(viewModel.memo)
                    .fontModifer(.b1m)
                    .foregroundStyle(Color.colors(.gray10))
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .roundedBorder()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
    
    @ViewBuilder func plusButtons() -> some View {
        HStack(spacing: 8) {
            if viewModel.memo.isEmpty {
                Button(action: {
                    viewModel.showMemoSheet = true
                }, label: {
                    plusLabel(title: "메모")
                })
            }
//            Button(action: {
//                
//            }, label: {
//                plusLabel(title: "사진 첨부")
//            })
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    @ViewBuilder func caddyContentRows() -> some View {
        listCell(
            image: .init(.coinDollar),
            title: "라운딩 수",
            isMandatory: true
        ) {
            CustomStepper(count: $viewModel.roundingCount)
        }
        
        listCell(
            image: .init(.coinDollar),
            title: "캐디피 수입",
            isMandatory: true
        ) {
            WonInput(text: $viewModel.caddyFee)
        }
        
        listCell(
            image: .init(.coinDollar),
            title: "오버피 수입"
        ) {
            WonInput(text: $viewModel.overFee)
        }
        
        listCell(
            image: .init(.coinDollar),
            title: "배토 여부"
        ) {
            Button(action: {
                viewModel.topDressing.toggle()
            }, label: {
                Image.icons(
                    viewModel.topDressing
                    ? .check_solid
                    : .check_outline
                )
                .resizable()
                .fixedSize()
                .frame(width: 20)
                .foregroundStyle(
                    Color.colors(
                        viewModel.topDressing
                        ? .primaryNormal
                        : .gray04
                    )
                )
            }).buttonStyle(.plain)
        }
    }
    
    @ViewBuilder func riderContentRows() -> some View {
        listCell(
            image: .init(.coinDollar),
            title: "배달 건수",
            isMandatory: true
        ) {
            CustomStepper(count: $viewModel.deliveryCount)
        }
        listCell(
            image: .init(.coinDollar),
            title: "배달 수입",
            isMandatory: true
        ) {
            WonInput(text: $viewModel.deliveryIncome)
        }
        listCell(
            image: .init(.coinDollar),
            title: "프로모션 건수"
        ) {
            CustomStepper(count: $viewModel.promotionCount)
        }
        listCell(
            image: .init(.coinDollar),
            title: "프로모션 수입"
        ) {
            WonInput(text: $viewModel.promotionIncome)
        }
    }
    
    @ViewBuilder func temporaryContentRows() -> some View {
        listCell(
            image: .init(.coinDollar),
            title: "현장",
            isMandatory: true
        ) {
            CustomTextField(
                text: $viewModel.placeName,
                placeholder: "근무 현장명 입력")
        }
        listCell(
            image: .init(.coinDollar),
            title: "일당",
            isMandatory: true
        ) {
            WonInput(text: $viewModel.dailyWage)
        }
        listCell(
            image: .init(.coinDollar),
            title: "직종"
        ) {
            CustomTextField(
                text: $viewModel.typeOfJob,
                placeholder: "직종명 입력")
        }
        listCell(
            image: .init(.coinDollar),
            title: "공수"
        ) {
            CustomDoubleStepper(count: $viewModel.numberOfWork)
        }
    }
    
    @ViewBuilder func contentHeader() -> some View {
        HStack(spacing: 5) {
            Text(format(date: viewModel.date))
                .fontModifer(.h7)
                .foregroundStyle(Color.colors(.gray10))
            Image.icons(.dropdown)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 44)
        .overlay(alignment: .leading) {
            DatePicker(
                "",
                selection: $viewModel.date,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .blendMode(.destinationOver)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder func 근무형태() -> some View {
        listCell(
            image: .init(.smileyHappy),
            title: "근무 형태",
            isMandatory: true
        ) {
            Button(action: {
                viewModel.send(.showScheduleTypeSheet)
            }, label: {
                HStack(spacing: 4) {
                    Text(viewModel.workType?.title ?? "선택")
                        .fontModifer(.b1m)
                        .foregroundStyle(Color.colors(
                            viewModel.workType != nil
                            ? .gray10
                            : .gray04
                        ))
                    Image.icons(.arrow_right)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                        .foregroundStyle(Color.colors(.gray06))
                }
            })
        }
    }
    
    @ViewBuilder func listCell(
        image: Image,
        title: String,
        isMandatory: Bool = false,
        trailingView: () -> some View
    ) -> some View {
        HStack {
            cellLabel(
                image: image,
                title: title,
                isMandatory: isMandatory)
            Spacer()
            trailingView()
        }
        .frame(height: 56)
        .padding(.horizontal, 20)
        .drawUnderline()
    }
    
    @ViewBuilder func cellLabel(
        image: Image,
        title: String,
        isMandatory: Bool = false
    ) -> some View {
        HStack(spacing: 4) {
            image
            Text(title)
                .fontModifer(.b1m)
                .foregroundStyle(Color.colors(.cg06))
                .padding(.trailing, 2)
            if isMandatory {
                ChipView("필수", style: .red)
            }
            Spacer()
        }.frame(height: 24)
    }
    
    @ViewBuilder func bottomButton() -> some View {
        CustomButton(
            title: "수입 자랑하기✌️",
            foreground: .colors(.white),
            background: viewModel.isAvailable
                ? .colors(.black)
                : .colors(.gray04),
            action: { 
                viewModel.send(.boast)
            }
        ).padding(.vertical, 20)
    }
    
    @ViewBuilder func plusLabel(title: String) -> some View {
        HStack(spacing: 3) {
            Image.icons(.pluspx)
                .resizable()
                .scaledToFit()
                .frame(width: 18)
            Text(title)
                .fontModifer(.b1m)
        }
        .foregroundStyle(Color.colors(.cg06))
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .roundedBackground(
            .colors(.cg01),
            radius: 80)
    }
    
    @ViewBuilder func contentFooter() -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                contentFooterCell(
                    title: "총 수입",
                    chipTitle: "자동계산"
                ) {
                    Group {
                        if let totalSum =  viewModel.totalSum {
                            Text(totalSum + " 원")
                                .fontModifer(.b1m)
                                .foregroundStyle(Color.colors(.gray10))
                        } else {
                            Text("계산 중이에요")
                                .fontModifer(.b1m)
                                .foregroundStyle(Color.colors(.primaryNormal))
                        }
                    }
                }
                contentFooterCell(title: "지출액") {
                    WonInput(text: $viewModel.expenditure)
                }
                contentFooterCell(title: "저축액") {
                    WonInput(text: $viewModel.saving)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            Text("목표수입 \(viewModel.contributePercent ?? 0)% 기여")
                .frame(maxWidth: .infinity)
                .foregroundStyle(
                    viewModel.contributePercent != nil
                    ? Color.colors(.primaryNormal)
                    : Color.colors(.cg06)
                )
                .fontModifer(.b1m)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.colors(.cg01))
                .overlay(alignment: .top) {
                    CustomDivider(color: .colors(.cg03), padding: 0)
                }
        }
        .roundedBorder(.colors(.cg03))
        .padding(20)
    }
    
    @ViewBuilder func contentFooterCell(
        title: String,
        chipTitle: String? = .none,
        trailingView: () -> some View
    ) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(Color.colors(.cg06))
                .fontModifer(.b1m)
            if let chipTitle {
                ChipView(chipTitle)
            }
            Spacer()
            trailingView()
        }
        .frame(height: 24)
    }
}

fileprivate func format(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR") 
    dateFormatter.dateFormat = "MM.dd EEEE"
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return dateFormatter.string(from: date)
}
