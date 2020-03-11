//
//  SheetView.swift
//  Notate
//
//  Created by Artorias on 2020-03-10.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI

struct SheetView: View {
    @Binding var navigationBarIsHidden: Bool
    
    func getUrl() -> URL {
        let url = Bundle.main.url(forResource: "index", withExtension: "html")!
        return url
    }
    
    var body: some View {
        WebView(request: URLRequest(url: self.getUrl()))
            .navigationBarTitle("Lyrics", displayMode: .inline)
            .onAppear() {
                self.navigationBarIsHidden = true
            }
    }
}

//struct SheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        SheetView()
//    }
//}
