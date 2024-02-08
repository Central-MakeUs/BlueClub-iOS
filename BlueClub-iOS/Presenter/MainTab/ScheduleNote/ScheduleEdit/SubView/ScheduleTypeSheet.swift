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
            HStack {
                Text("근무 형태를 골라주세요.")
                Spacer()
                Button(action: {
                    viewModel.showScheduleTypeSheet = false
                }, label: {
                    Image.icons(.x)
                        .resizable()
                        .fixedSize()
                        .frame(width: 20)
                        .foregroundStyle(Color.colors(.black))
                })
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 14)
            .padding(.top, 32)
        } content: {
            VStack {
                ForEach(ScheduleType.allCases, id: \.self) { type in
                    Button(action: {
                        self.viewModel.scheduleType = type
                        viewModel.showScheduleTypeSheet = false
                    }, label: {
                        Text(type.title)
                            .fontModifer(.b1m)
                            .foregroundStyle(Color.colors(.gray07))
                            .frame(height: 56)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 10)
                            .drawUnderline()
                            .padding(.horizontal, 20)
                    })
                }
            }
        }
    }
}
