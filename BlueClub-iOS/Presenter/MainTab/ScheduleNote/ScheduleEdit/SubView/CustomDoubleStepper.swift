//
//  CustomDoubleStepper.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 2/7/24.
//

import SwiftUI
import DesignSystem

struct CustomDoubleStepper: View {
    
    @Binding var count: Double
    var decreaseAvailable: Bool { count > 0 }
    var increaseAvailable: Bool { 3.0 > count }
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                guard decreaseAvailable else { return }
                count -= 0.1
            }, label: {
                Image.icons(.minuspx)
                    .resizable()
                    .fixedSize()
                    .frame(width: 18)
                    .foregroundStyle(Color.colors(
                        decreaseAvailable
                        ? .gray06
                        : .gray04
                    ))
            }).buttonStyle(.plain)
            Text(String(count))
                .fontModifer(.sb1)
                .foregroundStyle(Color.colors(.gray10))
                .frame(width: 48)
                .monospaced()
            Button(action: {
                guard increaseAvailable else { return }
                count += 0.1
            }, label: {
                Image.icons(.pluspx)
                    .resizable()
                    .fixedSize()
                    .frame(width: 18)
                    .foregroundStyle(Color.colors(
                        increaseAvailable
                        ? .gray06
                        : .gray04
                    ))
            }).buttonStyle(.plain)
        }
        .frame(height: 42)
        .onChange(of: count, { oldValue, newValue in
            count = (count * 10).rounded() / 10
        })
    }
}
