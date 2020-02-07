//
//  SingleKeyTestView.swift
//  Notate
//
//  Created by Yilun Huang on 2020-02-04.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

struct SingleKeyTestView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    func anaTest(){
        var A = AudioAnalyze()
        A.analysis()
    }
    var body: some View {
        VStack{
            Button(action: {self.audioRecorder.startRecording()}) {
                Image(systemName: "circle.fill")
                .frame(width:100,height: 100)
                    //...
            }
            
            Button(action: {self.audioRecorder.stopRecording()}) {
                Image(systemName: "stop.fill")
                .frame(width:100,height: 100)
                    //...
            }
            
            Button(action: self.anaTest){
                Image(systemName: "camera")
                    .frame(width:100,height: 100)
            }
            
        }
    }
}


struct SingleKeyTestView_Previews: PreviewProvider {
    static var previews: some View {
        SingleKeyTestView(audioRecorder: AudioRecorder())
    }
}
