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
    
    var body: some View {
        VStack {
            Stepper("\(timerhelper.bpm) BPM", value: $timerhelper.bpm, in: 60...180)
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
        
    }
}

struct BPMSelectView_Previews: PreviewProvider {
    static var previews: some View {
        BPMSelectView(timerhelper: TimerHelper())
    }
}
