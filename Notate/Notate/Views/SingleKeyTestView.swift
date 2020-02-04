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
    var body: some View {
        VStack{
            Button(action: {self.audioRecorder.startRecording()}) {
                Image(systemName: "circle.fill")
                    //...
            }
            
            Button(action: {self.audioRecorder.stopRecording()}) {
                Image(systemName: "stop.fill")
                    //...
            }
        }
    }
}


struct SingleKeyTestView_Previews: PreviewProvider {
    static var previews: some View {
        SingleKeyTestView(audioRecorder: AudioRecorder())
    }
}
