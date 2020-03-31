//
//  BrowseView.swift
//  Notate
//
//  Created by Artorias on 2020-03-31.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI

struct BrowseView: View {
    @EnvironmentObject var observed: Observed
    @State var file_list = [String]()
    @State var notes = ""
    @State var hide_navi_bar = false
    
    func loadSongList () {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentPath.appendingPathComponent("songs.txt")
        do {
            let shit = try String(contentsOf: filePath, encoding: .utf8)
            let temp = shit.components(separatedBy: " ")
            self.file_list = Array(temp[1...])
            print(self.file_list)
        }
        catch {
            print("Error!")
        }
    }
    
    func getContent (name: String) {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentPath.appendingPathComponent("\(name)_song.txt")
        do {
            let content = try String(contentsOf: filePath, encoding: .utf8)
            var temp = content.components(separatedBy: "\n")
            temp.removeLast()
            observed.notes = temp
//            print(temp)
        }
        catch {
            print("Error!")
        }
    }
    
    func getLyrics(name: String) {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentPath.appendingPathComponent("\(name).txt")
        do {
            let content = try String(contentsOf: filePath, encoding: .utf8)
            var temp = content.components(separatedBy: "\n")
            observed.lyrics = temp
            print(temp)
        }
        catch {
            print("Error!")
            observed.lyrics = []
        }
    }
    
    var body: some View {
        NavigationView {
            List {
               ForEach(self.file_list, id: \.self) { file in
                   NavigationLink(destination:
                    SheetView(hide_navi_bar: self.$hide_navi_bar, notes: []).onAppear(){
                        self.getContent(name: file)
                        self.getLyrics(name: file)
                    }
                       .navigationBarTitle("", displayMode: .inline)
                   ) {
                    Text(file)
                   }
                
                
//                Button(action: {
//                    self.getContent(name: file)
//                }) {
//                    Text(file)
//                }
               }
           }
        }
        .navigationBarTitle("Scores", displayMode: .inline)
        .onAppear() {
            self.loadSongList()
            self.hide_navi_bar = false
        }
        
       
        
    }
    
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
