//
//  GoalInputSheetView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/3/24.
//

import SwiftUI
import DesignSystem

struct GoalInputSheetView: View {
    
    @State var text = ""
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
                message: .none,
                focusState: $focus,
                focusValue: true)
        } footer: {
            footer()
        }.onAppear { focus = true }
    }
    
    @ViewBuilder func header() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("매달 목표 수입 설정")
                    .fontModifer(.h6)
                    .foregroundStyle(Color.colors(.gray10))
                Spacer()
                Button {
                    coordinator?.navigator.dismiss()
                } label: {
                    Image.icons(.x)
                        .foregroundStyle(Color.colors(.gray10))
                }
            }
            Text("목표 금액은 최소 10만 원부터 입력해주세요.")
                .fontModifer(.b2m)
                .foregroundStyle(Color(hex: "7C7C7C"))
        }
        .padding(.horizontal, 30)
        .padding(.top, 32)
        .padding(.bottom, 14)
    }
    
    @ViewBuilder func footer() -> some View {
        PrimaryButton(
            title: "다음",
            disabled: false,
            action: { }
        ).padding(.vertical, 20)
    }
}

#Preview {
    GoalInputSheetView(viewModel: .init(coordinator: .init(navigator: .init())), coordinator: .init(navigator: .init()))
}
