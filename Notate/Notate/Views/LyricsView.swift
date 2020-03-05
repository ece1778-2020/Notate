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
//                self.printFile()
//            }) {
//                Text("test")
//            }
        }
            .navigationBarTitle("Lyrics", displayMode: .inline)
            
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
            }
        
    }
}

//struct LyricsView_Previews: PreviewProvider {
//    static var previews: some View {
//        LyricsView()
//    }
//}
