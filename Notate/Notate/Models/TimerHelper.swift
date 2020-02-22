//
//  TimerHelper.swift
//  Notate
//
//  Created by Artorias on 2020-02-06.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import Foundation
import SwiftUI

class TimerHelper: ObservableObject {
    @ObservedObject var audioRecorder = AudioRecorder()
    @Published var timer: Timer!
    @Published var count = 5
    @Published var stop = true
    @Published var recording = false
    @Published var bpm = 60
    
    let metronome = Metronome()
    
    func playMetronome () {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(withTimeInterval: 60.0 / Double(self.bpm), repeats: true, block: { _ in
                self.metronome.playSound(sound: "MetroBar1", type: "wav")
            })
        }
    }
    
    func stopMetronome() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func startRecording () {
        if self.timer == nil || self.stop == true {
            self.stop = false
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                self.metronome.playSound(sound: "MetroBar1", type: "wav")
                if self.count == 0 && self.recording == false {
                    self.audioRecorder.startRecording()
                    self.recording = true
                }
                
                if self.recording == false {
                    self.count -= 1
                }
                else {
                    self.count += 1
                }   
            })
            
        }
    }
    
    func finishRecording () {
        self.timer?.invalidate()
        self.stop = true
        if self.recording {
            self.recording = false
            self.audioRecorder.stopRecording()
        }
        self.count = 5
    }
    
}
