//
//  AllowView.swift
//  BlueClub-iOS
//
//  Created by 김인섭 on 1/7/24.
//

import SwiftUI
import DesignSystem

struct ServiceAgreementView: View {
    
    @Binding var hasAllow: Bool
    @State var checked: [AgreementRow] = []
    
    var allChecked: Bool {
        checked.count == AgreementRow.allCases.count
    }
    
    var body: some View {
        VStack(spacing: 20) {
            CheckListHeader(
                hasCheck: allChecked,
                title: "약관 전체 동의",
                onTap: {
                    checked = allChecked ? [] : AgreementRow.allCases
                }
            )
            listContent()
        }.onChange(of: checked, perform: { value in
            hasAllow = AgreementRow.mandatories.allSatisfy { value.contains($0) }
        })
    }
    
    @ViewBuilder func listContent() -> some View {
        VStack(spacing: 16) {
            ForEach(AgreementRow.allCases, id: \.title) { row in
                CheckListCell(
                    hasCheck: checked.contains(row),
                    title: row.title,
                    onTapCheck: { checked.toggle(row) }
                )
            }
        }
    }
}

extension ServiceAgreementView {
    
    enum AgreementRow: CaseIterable, Equatable {
        
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
    ServiceAgreementView(hasAllow: .constant(true))
}
