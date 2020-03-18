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
    @State var timeRemaining = 6
    @State var isRecorderStart : Bool = false
    @State var isRecorderStartAsyn : Bool = false
    @Binding var navigationBarIsHidden: Bool
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func anaTest(){

        var A = AudioAnalyze()
        self.FFTResults=A.analysis(fileName: "Test.m4a")
    }
    
    func stop_analysis(){
        if self.isRecorderStartAsyn{
            self.audioRecorder.stopRecording()
            self.anaTest()
            self.isRecorderStart=false
            self.isRecorderStartAsyn=false
            self.timeRemaining=6
            self.CountDownText=""
        }
    }
    
    func start_record(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.isRecorderStartAsyn=true
            self.audioRecorder.startRecording()
        }
        
        self.isRecorderStart=true
        self.timeRemaining=6
    }
    
    func get_start(){
        var A = AudioAnalyze()
//        print(A.multy_note(fileName: "Test.m4a"))
        
        self.FFTResults=A.multy_note(fileName: "Test.m4a")
        print(self.FFTResults[1].Note)
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
                
                Button(action: {self.get_start()}) {
                //                Image(systemName: "stop.fill")
                                Text("Get Start")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                                .padding()
                                .shadow(radius: 10)
                            }

                
                VStack {
                    Text("\(CountDownText)")
                        .font(.system(size:60))
                        .onReceive(timer) { _ in
                            if (self.timeRemaining > 1 && self.isRecorderStart) {
                                self.timeRemaining -= 1
                                self.CountDownText = "Starting in \(self.timeRemaining)"
                            }else if (self.timeRemaining == 1 && self.isRecorderStart){
                                self.timeRemaining -= 1
                                self.CountDownText = "Start"
                            }else if (self.isRecorderStart){
                                self.timeRemaining -= 1
                                self.CountDownText = "\(-self.timeRemaining)"
                            }
                        }
                    
//                    Spacer()
                    
                    
                    ScrollView{
                        Text("")
                            .frame(maxWidth: .infinity)
                        Text("\(self.FFTResults.count)")
                            .hidden()
                        ForEach(0..<self.FFTResults.count, id: \.self){(i) in
                            Text("\(self.FFTResults[i].Note)")
                            .font(.system(size:60))
                        }
                                
                    }
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height*0.3)
                }
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height*0.3)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding()
                    .opacity(0.7)
//                    .frame(width: UIScreen.main.bounds.size.width*0.8, height: UIScreen.main.bounds.size.height*0.7)
//
            }.offset(y:-UIScreen.main.bounds.size.height*0.08)
            
            
        }
            .navigationBarTitle("Record", displayMode: .inline)
            
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(
            Image("record_background")
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
