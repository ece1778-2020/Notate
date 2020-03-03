//
//  ContentView.swift
//  Notate
//
//  Created by Yilun Huang on 2020-02-04.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BPMSelectView(timerhelper: TimerHelper())
                .tabItem {
                    Text("Metronome")
            }
            
            LyricsView()
                .tabItem {
                    Text("Lyrics Page")
            }
            
            SingleKeyTestView(audioRecorder: AudioRecorder())
                .tabItem {
                    Text("Single Pitch Test")
            }
            
        }
//        TimerView(timerhelper: TimerHelper())
//        SingleKeyTestView(audioRecorder: AudioRecorder())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
