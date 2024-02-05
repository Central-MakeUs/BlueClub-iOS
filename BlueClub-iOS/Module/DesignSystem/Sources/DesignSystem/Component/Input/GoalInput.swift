//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 2/3/24.
//

import SwiftUI
import Combine

public struct GoalInput<T: Hashable>: View {
    
    @Binding var text: String
    @Binding var isValid: Bool
    @State var message: (String, Color)?
    let focusState: FocusState<T?>.Binding
    let focusValue: T
    
    public init(
        text: Binding<String>,
        isValid: Binding<Bool>,
        focusState: FocusState<T?>.Binding,
        focusValue: T
    ) {
        self._text = text
        self._isValid = isValid
        self.focusState = focusState
        self.focusValue = focusValue
    }
    
    public var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                TextField("", text: $text)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .focused(focusState, equals: focusValue)
                Text("원")
                    .hide(when: text.isEmpty)
            }
            .fontModifer(.b1)
            .frame(height: 24)
            .foregroundStyle(Color.colors(.gray10))
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .background(alignment: .trailing, content: {
                if text.isEmpty {
                    Text("목표 금액 입력")
                        .fontModifer(.b1)
                        .foregroundStyle(Color.colors(.gray06))
                        .padding(.trailing, 12)
                }
            })
            .roundedBackground(
                .colors(.gray01),
                radius: 8
            )
            if let message {
                Text(message.0)
                    .fontModifer(.caption1)
                    .foregroundStyle(message.1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .frame(height: 18)
                    .padding(.horizontal, 8)
            }
        }
        .padding(.horizontal, 20)
        .onReceive(Just(text)) { _ in handleTextChanged() }
    }
}

extension GoalInput {
    
    func handleTextChanged() {
        let target = text.replacingOccurrences(of: ",", with: "")
        if target.isEmpty {
            self.message = .none
        }
        guard let integer = Int(target) else {
            return self.text = ""
        }
        self.text = formatNumber(integer)
        switch integer {
        case 100000...99990000:
            self.message = (
                "멋진 목표 금액이에요!",
                Color.colors(.primaryNormal))
            self.isValid = true
        case ..<100000:
            self.message = (
                "10만원 이상 입력해주세요.",
                Color.colors(.error))
            self.isValid = false
        case 99990001...:
            self.message = (
                "9,999만원 이하 입력해주세요.",
                Color.colors(.error))
            self.isValid = false
        default:
            break
        }
    }
}

fileprivate func formatNumber(_ number: Int) -> String {
    formatter.string(from: NSNumber(value: number)) ?? ""
}

fileprivate var formatter: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    formatter.groupingSeparator = ","
    formatter.usesGroupingSeparator = true
    return formatter
}


//#Preview {
//    GoalInput(
//        text: .init(projectedValue: ""),
//        message: <#T##(String, Color)?#>,
//        focusState: .init(,
//        focusValue: true)
//}
