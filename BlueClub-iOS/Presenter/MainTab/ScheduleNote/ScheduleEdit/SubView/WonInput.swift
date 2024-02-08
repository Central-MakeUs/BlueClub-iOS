//
//  WonInput.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/7/24.
//

import SwiftUI
import DesignSystem
import Combine

struct WonInput: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Spacer()
            TextField("", text: $text)
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad)
            if !text.isEmpty {
                Text("원")
            }
        }
        .foregroundStyle(Color.colors(.gray10))
        .fontModifer(.b1m)
        .background(alignment: .trailing, content: {
            if text.isEmpty {
                Text("금액 입력")
                    .fontModifer(.b1m)
                    .foregroundStyle(Color.colors(.gray04))
            }
        })
        .onReceive(Just(text)) { _ in handleTextChanged() }
    }
}

private extension WonInput {
    
    func handleTextChanged() {
        let target = text.replacingOccurrences(of: ",", with: "")
        guard let integer = Int(target) else {
            return self.text = ""
        }
        self.text = formatNumber(integer)
    }
    
    func formatNumber(_ number: Int) -> String {
        formatter.string(from: NSNumber(value: number)) ?? ""
    }

    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        return formatter
    }
}
