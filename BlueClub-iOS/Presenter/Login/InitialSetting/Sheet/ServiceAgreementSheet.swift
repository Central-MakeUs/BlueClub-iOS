//
//  AllowView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/6/24.
//

import SwiftUI
import DesignSystem

struct ServiceAgreementSheet: View {
    
    @Binding var isPresented: Bool
    let onFinish: (Bool) -> Void
    @State var hasAllow = false
    @State var hasAllowTos = false
    
    init(
        isPresented: Binding<Bool>,
        onFinish: @escaping (Bool) -> Void
    ) {
        self._isPresented = isPresented
        self.onFinish = onFinish
    }
    
    var body: some View {
        BaseView {
            SheetHeader(
                title: "블루클럽을 이용하려면,\n정보 동의가 필요해요.",
                dismiss: { isPresented = false }
            )
        } content: {
            ServiceAgreementView(
                hasAllow: $hasAllow,
                hasAllowTos: $hasAllowTos)
        } footer: {
            GrayButton(
                title: "확인",
                disabled: !hasAllow,
                action: { onFinish(hasAllowTos) }
            )
            .padding(.vertical, 20)
            .disabled(!hasAllow)
        }
    }
}

extension ServiceAgreementSheet {
    
    enum AllowRow: CaseIterable, Equatable {
        
        case 개인정보, 서비스, 제3자, 휴대푠, 마케팅
        
        var title: String {
            switch self {
            case .개인정보:
                return "개인정보 수집·이용 정책 동의 (필수)"
            case .서비스:
                return "서비스 이용약관 동의 (필수)"
            case .제3자:
                return "제 3자 제공 동의 (필수)"
            case .휴대푠:
                return "휴대폰 본인확인 서비스 동의 (필수)"
            case .마케팅:
                return "마케팅 활용정보 동의 (선택)"
            }
        }
        
        var isMandatory: Bool {
            switch self {
            case .마케팅:
                return false
            default:
                return true
            }
        }
        
        static let mandatories: [Self] = Self.allCases.filter { $0.isMandatory }
    }
}

#Preview {
    ServiceAgreementSheet(isPresented: .constant(true), onFinish: { _ in })
}
