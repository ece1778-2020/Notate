//
//  WebView.swift
//  Notate
//
//  Created by Artorias on 2020-03-10.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}
