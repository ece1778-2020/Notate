//
//  LyricsView.swift
//  Notate
//
//  Created by Artorias on 2020-03-02.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI

struct LyricsView: View {
    @State var text: String = ""
    
    var body: some View {
        VStack {
            Button(action: {
                //
            }) {
                Text("Save")
            }
            TextView(text: $text)
            
        }
        
    }
}

struct LyricsView_Previews: PreviewProvider {
    static var previews: some View {
        LyricsView()
    }
}
