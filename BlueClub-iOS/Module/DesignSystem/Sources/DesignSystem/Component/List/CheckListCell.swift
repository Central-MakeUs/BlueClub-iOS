//
//  SwiftUIView.swift
//  
//
//  Created by 김인섭 on 1/7/24.
//

import SwiftUI
import WebKit

public struct CheckListCell: View {
    
    let hasCheck: Bool
    let title: String
    let webPageUrl: String?
    let onTapCheck: () -> Void
    
    @State var showWeb = false
    
    public init(
        hasCheck: Bool,
        title: String,
        webPageUrl: String?,
        onTapCheck: @escaping () -> Void
    ) {
        self.hasCheck = hasCheck
        self.title = title
        self.webPageUrl = webPageUrl
        self.onTapCheck = onTapCheck
    }
    
    public var body: some View {
        HStack {
            Button {
                onTapCheck()
            } label: {
                HStack(spacing: 6) {
                    Image.icons(
                        hasCheck
                        ? .check_active
                        : .check_deactive)
                    Text(title)
                        .fontModifer(.b2m)
                        .foregroundStyle(Color.colors(.gray07))
                }
            }
            Spacer()
            if webPageUrl != nil {
                Button {
                    self.showWeb = true
                } label: {
                    Icons.arrow_right.image
                        .foregroundStyle(Color.colors(.gray05))
                }
            }
        }
        .background(Color.white)
        .frame(height: 24)
        .padding(.horizontal, 33)
        .sheet(isPresented: $showWeb, content: {
            if let webPageUrl, let url = URL(string: webPageUrl) {
                WebView(url: url)
            }
        })
    }
}

fileprivate struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}


#Preview {
    CheckListCell(
        hasCheck: true,
        title: "개인정보 수집·이용 정책 동의 (필수)",
        webPageUrl: "https://www.notion.so/0905a99459cf470f908018d20f0d8d72?pvs=4",
        onTapCheck: { print("check tap") }
    )
}
