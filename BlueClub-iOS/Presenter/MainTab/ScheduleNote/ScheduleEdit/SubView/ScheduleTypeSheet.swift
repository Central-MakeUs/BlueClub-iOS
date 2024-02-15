//
//  ScheduleTypeSheet.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/7/24.
//

import SwiftUI
import DesignSystem
import Domain

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
                ForEach(WorkType.allCases, id: \.self) { type in
                    Button(action: {
                        self.viewModel.workType = type
                        viewModel.showScheduleTypeSheet = false
                    }, label: {
                        SheetCellRow(title: type.title)
                    })
                }
            }
        }
    }
}
