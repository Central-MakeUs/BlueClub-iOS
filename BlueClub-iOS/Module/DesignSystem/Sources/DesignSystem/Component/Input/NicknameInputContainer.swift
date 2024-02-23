//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 2/8/24.
//

import SwiftUI

public struct NicknameInputContainer<Content: View>: View {
    
    var isLoading: Bool
    let nickname: String
    let isValid: Bool
    let message: InputStatusMessages?
    let onTapCheck: () -> Void
    let content: () -> Content
    
    public init(
        isLoading: Bool,
        nickname: String,
        isValid: Bool,
        message: InputStatusMessages?,
        onTapCheck: @escaping () -> Void,
        content: @escaping () -> Content
    ) {
        self.isLoading = isLoading
        self.nickname = nickname
        self.isValid = isValid
        self.message = message
        self.onTapCheck = onTapCheck
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 2) {
            content()
                .overlay(alignment: .trailing) {
                    Text("중복확인")
                        .fontModifer(.sb3)
                        .foregroundStyle(
                            isLoading
                            ? Color.colors(.gray08)
                            : Color.colors(.white)
                        )
                        .padding(.vertical, 6)
                        .padding(.horizontal, 6)
                        .roundedBackground(
                            isValid
                            ? .colors(.gray10)
                            : .colors(.gray04),
                            radius: 4
                        )
                        .onTapGesture {
                            guard !isLoading else { return }
                            onTapCheck()
                        }
                        .overlay {
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .padding(.trailing, 12)
                }
            HStack {
                HStack(spacing: 3) {
                    Text("\(nickname.count)")
                        .foregroundStyle(Color.colors(.gray07))
                    Text("/")
                        .foregroundStyle(Color.colors(.gray05))
                    Text("10")
                        .foregroundStyle(Color.colors(.gray07))
                }.fontModifer(.caption1)
                Spacer()
                    if let message {
                        Text(message.message)
                            .fontModifer(.caption1)
                            .foregroundStyle(message.color)
                    }
            }
            .frame(height: 18)
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 20)
    }
}

public enum InputStatusMessages {
    case 사용가능닉네임, 중복닉네임, 닉네임유효성에러, 목표금액기준미만, 목표금액기준만족, 목표금액초과
    
    public var message: String {
        switch self {
        case .사용가능닉네임:
            return "사용 가능한 닉네임입니다."
        case .중복닉네임:
            return "이미 사용 중인 닉네임입니다."
        case .닉네임유효성에러:
            return "띄어쓰기 없이 한글, 영문, 숫자만 가능해요"
        case .목표금액기준미만:
            return "10만원 이상 입력해주세요."
        case .목표금액기준만족:
            return "멋진 목표 금액이에요!"
        case .목표금액초과:
            return "9,999만원 이하 입력해주세요."
        }
    }
    
    public var color: Color {
        switch self {
        case .사용가능닉네임, .목표금액기준만족:
            return Color.colors(.primaryNormal)
        case .중복닉네임, .닉네임유효성에러, .목표금액기준미만, .목표금액초과:
            return Color.colors(.error)
        }
    }
}
