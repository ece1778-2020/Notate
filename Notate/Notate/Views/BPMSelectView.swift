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
    
    func adjustMetronome () -> Double {
        self.timerhelper.updateInterval()
        return self.timerhelper.bpm
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("\(Int(adjustMetronome())) BPM")
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
            .background(Color.white)
            .cornerRadius(20)
            .opacity(0.7)
            
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(
        Image("background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
        )
        
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
