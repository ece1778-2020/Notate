//
//  LyricsView.swift
//  Notate
//
//  Created by Artorias on 2020-03-02.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI

struct LyricsView: View {
    @State var text: String = ""
    @State var filename: String = ""
    @State var show_alert = false
    @State var alert_message = ""
    @EnvironmentObject var obj: Observed
    @Binding var navigationBarIsHidden: Bool
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveFile() {
        if self.filename == "" {
            self.alert_message = "Invalid filename!"
            self.show_alert.toggle()
        }
        else if self.text == "" {
            self.alert_message = "Empty lyrics!"
            self.show_alert.toggle()
        }
        else {
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documentPath.appendingPathComponent("\(self.filename).txt")
            let str = self.text
            do {
                try str.write(to: url, atomically: true, encoding: .utf8)
                self.alert_message = "Success!"
                self.show_alert.toggle()
            } catch {
                self.alert_message = error.localizedDescription
                self.show_alert.toggle()
            }
        }
    }
    
    func printFile () {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // filename here
        
        let filePath = documentPath.appendingPathComponent("lyrics.txt")
        do {
            let content = try String(contentsOf: filePath, encoding: .utf8)
            print(content)
        }
        catch {
            print("Error")
        }
        
    }
    
    var body: some View {
        ScrollView {
            Image("lyrics_top")
            .resizable()
            .frame(maxWidth: .infinity)
            .aspectRatio(contentMode: .fit)
            TextView(text: $text)
                .background(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                .cornerRadius(10)
                .frame(height: self.obj.size)
            HStack {
                TextField("Filename", text: $filename)
                    .padding()
                Spacer()
                Button(action: {
                    self.saveFile()
                }) {
                    Text("Save")
                        .padding()
                }
            }
//            Button(action: {
//                self.printFile()
//            }) {
//                Text("test")
//            }
        }
            
        .alert(isPresented: self.$show_alert) {
            Alert(title: Text(self.alert_message))
        }
        
        .onAppear() {
            self.navigationBarIsHidden = false
        }
        
    }
}

//struct LyricsView_Previews: PreviewProvider {
//    static var previews: some View {
//        LyricsView()
//    }
//}
