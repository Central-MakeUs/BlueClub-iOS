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
    @Binding var hasAllowTos: Bool
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
            hasAllowTos = value.contains(.마케팅)
        })
    }
    
    @ViewBuilder func listContent() -> some View {
        VStack(spacing: 16) {
            ForEach(AgreementRow.allCases, id: \.title) { row in
                CheckListCell(
                    hasCheck: checked.contains(row),
                    title: row.title,
                    webPageUrl: row.webPageUrl,
                    onTapCheck: { checked.toggle(row) }
                )
            }
        }
    }
}

extension ServiceAgreementView {
    
    enum AgreementRow: CaseIterable, Equatable {
        
        case 만14세, 서비스, 개인정보, 마케팅, 이벤트수신
        
        var title: String {
            switch self {
            case .만14세:
                return "(필수) 만 14세 이상입니다."
            case .서비스:
                return "(필수)서비스 이용약관 동의"
            case .개인정보:
                return "(필수) 개인정보 처리방침 동의"
            case .마케팅:
                return "(선택) 마케팅 수신 동의"
            case .이벤트수신:
                return "(선택) 이벤트 앱 푸시 수신 동의"
            }
        }
        
        var isMandatory: Bool {
            switch self {
            case .이벤트수신, .마케팅:
                return false
            default:
                return true
            }
        }
        
        var webPageUrl: String? {
            switch self {
            case .서비스:
                return "https://www.notion.so/0905a99459cf470f908018d20f0d8d72?pvs=4"
            case .개인정보:
                return "https://www.notion.so/ded29418f6604ad993b0d664a653c4d7?pvs=4"
            default:
                return nil
            }
        }
        
        static let mandatories: [Self] = Self.allCases.filter { $0.isMandatory }
    }
}

#Preview {
    ServiceAgreementView(hasAllow: .constant(true), hasAllowTos: .constant(false))
}
