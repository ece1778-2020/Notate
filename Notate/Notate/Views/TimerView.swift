//
//  TimerView.swift
//  Notate
//
//  Created by Artorias on 2020-02-06.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var timerhelper: TimerHelper
    
    var body: some View {
        VStack {
            if self.timerhelper.recording {
                Text("Recording...")
            }
            else {
                Text("Start recording in")
            }
            
            Spacer()
                .frame(height: 30)
            
            Text("\(self.timerhelper.count)")
            
            Spacer()
                .frame(height: 30)
            
            HStack {
                Button(action: {
                    self.timerhelper.startRecording()
                }) {
                    Text("Start")
                }
                
                Spacer()
                    .frame(width: 40)
                
                Button(action: {
                    self.timerhelper.finishRecording()
                }) {
                    Text("Stop")
                }
            }
            .font(.headline)
            
        }
        
    }
        
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerhelper: TimerHelper())
    }
}
