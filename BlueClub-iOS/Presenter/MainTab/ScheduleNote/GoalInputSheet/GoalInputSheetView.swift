//
//  GoalInputSheetView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/3/24.
//

import SwiftUI
import DesignSystem
import Combine

struct GoalInputSheetView: View {
    
    @State var text = ""
    @State var isValid = false
    @FocusState var focus: Bool?
    
    @StateObject var viewModel: ScheduleNoteViewModel
    weak var coordinator: ScheduleNoteCoordinator?
    
    init(
        viewModel: ScheduleNoteViewModel,
        coordinator: ScheduleNoteCoordinator
    ) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        BaseView {
            header()
        } content: {
            GoalInput(
                text: $text, 
                isValid: $isValid,
                focusState: $focus,
                focusValue: true)
        } footer: {
            PrimaryButton(
                title: "다음",
                disabled: !isValid,
                action: {
                    let target = text.removeComma()
                    viewModel.send(.setMonthlyGoal(target))
                }
            ).padding(.vertical, 20)
        }
        .onAppear { focus = true }
    }
    
    @ViewBuilder func header() -> some View {
        SheetHeader(
            title: "매달 목표 수입 설정",
            description: "목표 금액은 최소 10만 원부터 입력해주세요.",
            dismiss: {
                coordinator?.navigator.dismiss()
            }
        )
    }
}

