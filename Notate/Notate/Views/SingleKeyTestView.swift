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
    @State var CountDownText: String = ""
    @State var timeRemaining = 3
    @State var isRecorderStart : Bool = false
    @Binding var navigationBarIsHidden: Bool
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func anaTest(){

        var A = AudioAnalyze()
        self.FFTResults=A.analysis(fileName: "Test.m4a")
    }
    
    func stop_analysis(){
        self.audioRecorder.stopRecording()
        self.anaTest()
        self.isRecorderStart=false
        self.timeRemaining=3
        self.CountDownText=""
    }
    
    func start_record(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.audioRecorder.startRecording()
                        }
        
        self.isRecorderStart=true
        self.timeRemaining=3
    }
    
    var body: some View {
        VStack{
            VStack {
                Button(action: {self.start_record()}) {
    //                Image(systemName: "circle.fill")
                    Text("Start Record")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                    .padding()
                    .shadow(radius: 10)
                }
                
                Button(action: {self.stop_analysis()}) {
    //                Image(systemName: "stop.fill")
                    Text("Stop Record")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                    .padding()
                    .shadow(radius: 10)
                }
                
//                Button(action: self.anaTest){
//                    Text("FFT")
//                        .frame(width:100,height: 100)
//                }
                
                VStack {
                    Text("\(CountDownText)")
                        .onReceive(timer) { _ in
                            if (self.timeRemaining > 0 && self.isRecorderStart) {
                                self.timeRemaining -= 1
                                self.CountDownText = "\(self.timeRemaining)"
                            }else if (self.timeRemaining == 0 && self.isRecorderStart){
                                self.timeRemaining -= 1
                                self.CountDownText = "Start"
                            }else if (self.isRecorderStart){
                                self.timeRemaining -= 1
                                self.CountDownText = "\(-self.timeRemaining)"
                            }
                        }

                    
                    Text("\(self.FFTResults.count)")
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .opacity(0.7)
                        .padding()
                    ScrollView{
                        
                        ForEach(0..<self.FFTResults.count, id: \.self){(i) in
                            Text("\(self.FFTResults[i].Note) / \(self.FFTResults[i].freq)")

                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .opacity(0.7)
                        .padding()
                        
                    }
                }
//                .frame(maxWidth: 200, maxHeight: 300)
//                .background(Color.white)
//                .cornerRadius(20)
//                .opacity(0.7)
//
            }
            
            
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


//struct SingleKeyTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleKeyTestView(audioRecorder: AudioRecorder())
//    }
//}
