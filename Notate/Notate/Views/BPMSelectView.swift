//
//  BPMSelectView.swift
//  Notate
//
//  Created by Artorias on 2020-02-22.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI

struct BPMSelectView: View {
    @ObservedObject var timerhelper: TimerHelper
    @Binding var navigationBarIsHidden: Bool
    var body: some View {
        VStack {
            Text("\(Int(timerhelper.bpm)) BPM")
                .padding()
            Slider(value: $timerhelper.bpm, in: 60...180, step: 1)
                .padding()
            HStack {
                Button(action: {
                    self.timerhelper.playMetronome()
                }) {
                    Text("play")
                        .padding()
                }
                
                Button(action: {
                    self.timerhelper.stopMetronome()
                }) {
                    Text("stop")
                        .padding()
                }
            }
            
        }
        .onAppear() {
        self.navigationBarIsHidden = false
    }
    
    }
}

//struct BPMSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        BPMSelectView(timerhelper: TimerHelper())
//    }
//}
