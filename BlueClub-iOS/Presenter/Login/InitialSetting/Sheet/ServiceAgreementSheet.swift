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

#Preview {
    ServiceAgreementSheet(isPresented: .constant(true), onFinish: { _ in })
}
