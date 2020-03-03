//
//  TextView.swift
//  Notate
//
//  Created by Artorias on 2020-03-02.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    @EnvironmentObject var obj: Observed
    
    typealias UIViewType = UITextView
    
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.text = "Your Lyrics Here"
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        self.obj.size = textView.contentSize.height
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<TextView>) {
        uiView.text = text
        uiView.delegate = context.coordinator
        
    }
    
//    func frame(numLines: CGFloat) -> some View {
//        let height = UIFont.systemFont(ofSize: 17).lineHeight * numLines
//        return self.frame(height: height)
//    }
    
    func makeCoordinator() -> TextView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        init (_ parent: TextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            self.parent.obj.size = textView.contentSize.height
        }
        
    }
}

class Observed: ObservableObject {
    @Published var size: CGFloat = 0
}
