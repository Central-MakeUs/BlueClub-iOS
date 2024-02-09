//
//  ScheduleTypeSheet.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/7/24.
//

import SwiftUI
import DesignSystem

struct ScheduleTypeSheet: View {
    
    @EnvironmentObject var viewModel: ScheduleEditViewModel
    
    var body: some View {
        BaseView {
            SheetHeader(
                title: "근무 형태를 골라주세요.",
                dismiss: {  
                    viewModel.showScheduleTypeSheet = false
                }
            )
        } content: {
            VStack {
                ForEach(ScheduleType.allCases, id: \.self) { type in
                    Button(action: {
                        self.viewModel.scheduleType = type
                        viewModel.showScheduleTypeSheet = false
                    }, label: {
                        SheetCellRow(title: type.title)
                    })
                }
            }
        }
    }
}
