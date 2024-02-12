//
//  File.swift
//  
//
//  Created by 김인섭 on 2/13/24.
//

import WebKit
import Foundation
import SwiftUI

public struct WebView: UIViewRepresentable {
    
    let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
