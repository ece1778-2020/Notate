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
    let notes: [String]
    let lyrics: [String]
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let json: [String: Any] = ["notes": notes, "lyrics": lyrics]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "https://rc69q6tn5e.execute-api.us-east-1.amazonaws.com/dev")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
        uiView.load(request)
    }
}
