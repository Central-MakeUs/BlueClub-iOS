//
//  DiaryListCell.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/12/24.
//

import SwiftUI
import DesignSystem
import Domain

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
        inputFormatter.locale = Locale(identifier: "ko_KR")
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: input) else { return "" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "MM.dd E"
        let output = outputFormatter.string(from: date)
        return output
    }
}
