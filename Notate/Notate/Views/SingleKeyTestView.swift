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
    @State var FFTResults : [FFTResult]=[]
    func anaTest(){
        var A = AudioAnalyze()
        self.FFTResults=A.analysis(fileName: "Test.m4a")
    }
    var body: some View {
        VStack{

            Button(action: {self.audioRecorder.startRecording()}) {
//                Image(systemName: "circle.fill")
                Text("Start Record")
                .frame(width:100,height: 100)
                    //...
            }
            
            Button(action: {self.audioRecorder.stopRecording()}) {
//                Image(systemName: "stop.fill")
                Text("Stop Record")
                .frame(width:100,height: 100)
                    //...
            }
            
            Button(action: self.anaTest){
                Text("FFT")
                    .frame(width:100,height: 100)
            }
            Text("\(self.FFTResults.count)")
            ScrollView{
                
                ForEach(0..<self.FFTResults.count, id: \.self){(i) in
                    Text("\(self.FFTResults[i].Note) / \(self.FFTResults[i].freq)")
                }
                
            }
            
        }
    }
}


struct SingleKeyTestView_Previews: PreviewProvider {
    static var previews: some View {
        SingleKeyTestView(audioRecorder: AudioRecorder())
    }
}
