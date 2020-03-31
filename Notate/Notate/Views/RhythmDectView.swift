//
//  RhythmDectView.swift
//  Notate
//
//  Created by Yilun Huang on 2020-03-19.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//


import Foundation
import SwiftUI
import Combine
import AVFoundation

struct RhythmDectView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @State var FFTResults : [FFTResult]=[]
    @State var CountDownText: String = ""
    @State var timeRemaining = 6
    @State var isRecorderStart : Bool = false
    @State var isRecorderStartAsyn : Bool = false
    @Binding var navigationBarIsHidden: Bool
    @State var show_sheet: Bool = false
    @State var hide_navi_bar = false
    @State var song_name = ""
    @State var alert_message = ""
    @State var show_alert = false
    @EnvironmentObject var observed: Observed
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func check_list () {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // filename here
        
        let filePath = documentPath.appendingPathComponent("songs.txt")
        do {
            let content = try String(contentsOf: filePath, encoding: .utf8)
            print(content)
        }
        catch {
            let content = ""
            let url = documentPath.appendingPathComponent("songs.txt")
            do {
                try content.write(to: url, atomically: true, encoding: .utf8)
            }
            catch {
                self.alert_message = error.localizedDescription
                self.show_alert.toggle()
            }
            
        }
    }
    
    
    func convertNoteToString () -> String {
        let notes = observed.notes
        var result = ""
        for i in notes {
            result = result + i + "\n"
        }
        return result
    }
    
    func add_file (name: String) {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentPath.appendingPathComponent("songs.txt")
        do {
            var file_list = try String(contentsOf: filePath, encoding: .utf8)
            var files = file_list.components(separatedBy: " ")
            if !files.contains(name) {
                files.append(name)
            }
            file_list = files.joined(separator: " ")
            let url = documentPath.appendingPathComponent("songs.txt")
            do {
                try file_list.write(to: url, atomically: true, encoding: .utf8)
                self.alert_message = "Success!"
                self.show_alert.toggle()
            }
            catch {
                self.alert_message = error.localizedDescription
                self.show_alert.toggle()
            }
            
        }
        catch {
            self.alert_message = error.localizedDescription
            self.show_alert.toggle()
        }
        
    }
    
    func saveSheet() {
        if self.song_name == "" || self.song_name == "songs" {
            self.alert_message = "Invalid name!"
            self.show_alert.toggle()
        }
        else if observed.notes == [] {
            self.alert_message = "Empty notes!"
            self.show_alert.toggle()
        }
        else if self.song_name.contains(" ") {
            self.alert_message = "No empty space allowed!"
            self.show_alert.toggle()
        }
        else{
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documentPath.appendingPathComponent("\(self.song_name)_song.txt")
            let str = self.convertNoteToString()
            do {
                try str.write(to: url, atomically: true, encoding: .utf8)
                self.add_file(name: self.song_name)
                print("Success")
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    

    
    func convertToNotes() {
        var index = 0
        var part = ""
        var output = [String]()
        for result in self.FFTResults {
            var cao = result.Note
            if cao.contains("#") {
                cao = String(cao[0]) + "#" + String(cao[1])
            }
            index += 1
            if part == "" {
                part = cao + "/q"
            }
            else {
                part = part + ", " + cao
            }
            if index == 4 {
                output.append(part)
                part = ""
                index = 0
            }
        }
        while index > 0 && index < 4 {
            part = part + ", " + "F4/r"
            index += 1
        }
        if part != "" {
            output.append(part)
        }
        observed.notes = output
        print(output)
        
    }
    
    func anaTest(){
        let A = AudioAnalyze()
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
        let A = AudioAnalyze()
//        print(A.multy_note(fileName: "Test.m4a"))
        
        self.FFTResults=A.multy_note(fileName: "Test.m4a")
        print(self.FFTResults[1].Note)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                Button(action: {self.start_record()}) {
                    Text("Start Record")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                    .padding()
                    .shadow(radius: 10)
                }
                
                Button(action: {
                    self.stop_analysis()
                    self.get_start()
                    self.convertToNotes()
                }) {
                    Text("Stop Record")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                    .padding()
                    .shadow(radius: 10)
                }
                
//                    Button(action: {
//
//                        self.show_sheet.toggle()
//                    }) {
//        //                Image(systemName: "stop.fill")
//                        Text("Sheet Music")
//                        .font(.subheadline)
//                        .frame(maxWidth: .infinity)
//                        .foregroundColor(Color.white)
//                        .padding()
//                        .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
//                        .padding()
//                        .shadow(radius: 10)
//                    }

                NavigationLink(destination:
                    SheetView(hide_navi_bar: self.$hide_navi_bar, notes: observed.notes)
                        .onAppear(){
                            self.observed.lyrics = []
                    }
                    .navigationBarTitle("", displayMode: .inline)
                ) {
                    Text("Sheet Music")
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
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                    
                    
                }
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding()
                    .opacity(0.7)
                                    
                            
                HStack {
                    Spacer()
                        .frame(width: 10)
                    TextField("Name", text: self.$song_name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .opacity(0.7)
                        
                    Spacer()
                    Button(action: {
                        self.saveSheet()
                    }) {
                        Text("Save")
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                            .padding()
                            .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                            .cornerRadius(10)
                            .padding()
                            .shadow(radius: 10)
                            
                    }
                }

                                
            }
//                .navigationBarTitle("Record", displayMode: .inline)
                
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(
                Image("record_background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                )
                
                .alert(isPresented: self.$show_alert) {
                    Alert(title: Text(self.alert_message))
                }
                
                .onAppear() {
                    self.check_list()
                    self.navigationBarIsHidden = false
                    self.hide_navi_bar = false
                    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
                }
            
            
        }
            .navigationBarTitle("Record", displayMode: .inline)
            .navigationBarHidden(self.hide_navi_bar)
            
    }
}



//
//struct RhythmDectView_Previews: PreviewProvider {
//    static var previews: some View {
//        RhythmDectView()
//    }
//}
