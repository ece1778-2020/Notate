//
//  SheetView.swift
//  Notate
//
//  Created by Artorias on 2020-03-10.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI

struct SheetView: View {
    @EnvironmentObject var observed: Observed
    @Binding var hide_navi_bar: Bool
    let notes: [String]
    
    func getUrl() -> URL {
        let url = Bundle.main.url(forResource: "index", withExtension: "html")!
        return url
    }
    
    var body: some View {
        WebView(request: URLRequest(url: URL(string: "https://www.google.ca")!), notes: observed.notes, lyrics: observed.lyrics)
            .navigationBarTitle("Lyrics", displayMode: .inline)
            .onAppear() {
                self.hide_navi_bar = true
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
            }
    }
}

//struct SheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        SheetView()
//    }
//}
