//
//  LyricsView.swift
//  Notate
//
//  Created by Artorias on 2020-03-02.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//
import Foundation
import SwiftUI

struct LyricsView: View {
    @State var text: String = ""
    @State var filename: String = ""
    @State var show_alert = false
    @State var alert_message = ""
    @State var show_sheet = false
    @EnvironmentObject var obj: Observed
    @Binding var navigationBarIsHidden: Bool
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveFile() {
        if self.filename == "" || self.filename == "files" {
            self.alert_message = "Invalid filename!"
            self.show_alert.toggle()
        }
        else if self.text == "" {
            self.alert_message = "Empty lyrics!"
            self.show_alert.toggle()
        }
        else if self.filename.contains(" ") {
            self.alert_message = "No empty space allowed in file name!"
            self.show_alert.toggle()
        }
        else {
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documentPath.appendingPathComponent("\(self.filename).txt")
            let str = self.text
            do {
                try str.write(to: url, atomically: true, encoding: .utf8)
                self.add_file(name: self.filename)
            } catch {
                self.alert_message = error.localizedDescription
                self.show_alert.toggle()
            }
        }
    }
    
    func add_file (name: String) {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentPath.appendingPathComponent("files.txt")
        do {
            var file_list = try String(contentsOf: filePath, encoding: .utf8)
            var files = file_list.components(separatedBy: " ")
            if !files.contains(name) {
                files.append(name)
            }
            file_list = files.joined(separator: " ")
            let url = documentPath.appendingPathComponent("files.txt")
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
    
    func test () {
        let inputString = "This123Is123A123Test"
        let splits = inputString.components(separatedBy: "123")
        print(splits)
    }
    
    func check_list () {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // filename here
        
        let filePath = documentPath.appendingPathComponent("files.txt")
        do {
            let content = try String(contentsOf: filePath, encoding: .utf8)
            print(content)
        }
        catch {
            let content = ""
            let url = documentPath.appendingPathComponent("files.txt")
            do {
                try content.write(to: url, atomically: true, encoding: .utf8)
            }
            catch {
                self.alert_message = error.localizedDescription
                self.show_alert.toggle()
            }
            
        }
    }
    
    var body: some View {
        ScrollView {
            
            Spacer()
                .frame(height: 20)
            
            TextView(text: $text)
                .background(Color.white)
                .cornerRadius(10)
                .opacity(0.7)
                .frame(height: self.obj.size)
                .padding(10)
            
            HStack {
                Spacer()
                    .frame(width: 10)
                TextField("Filename", text: $filename)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .opacity(0.7)
                    
                Spacer()
                Button(action: {
                    self.saveFile()
                }) {
                    Text("Save")
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                        .padding()
                        .shadow(radius: 10)
                        
                }
            }
//            Button(action: {
//
//            }) {
//                Text("test")
//            }
//                .font(.subheadline)
//                .foregroundColor(Color.white)
//                .padding()
//                .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
//                .padding()
//                .shadow(radius: 10)
        }
            .sheet(isPresented: self.$show_sheet, content: {
                ScoresView(lyrics: self.$text, file_name: self.$filename, show_sheet: self.$show_sheet)
            })
            .navigationBarTitle("Lyrics", displayMode: .inline)
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    self.show_sheet.toggle()
                }) {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.white)
                }
                
            })
            
            .alert(isPresented: self.$show_alert) {
                Alert(title: Text(self.alert_message))
            }
            
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(
            Image("lyrics_background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
            )
        
            .onAppear() {
                self.navigationBarIsHidden = false
                self.check_list()
            }
        
    }
}

//struct LyricsView_Previews: PreviewProvider {
//    static var previews: some View {
//        LyricsView()
//    }
//}
