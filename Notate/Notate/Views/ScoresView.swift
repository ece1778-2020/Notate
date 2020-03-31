//
//  ScoresView.swift
//  Notate
//
//  Created by Artorias on 2020-03-18.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI
import Foundation

struct ScoresView: View {
    @Binding var lyrics: String
    @Binding var file_name: String
    @Binding var show_sheet: Bool
    @State var file_list = [String]()
    @EnvironmentObject var observed: Observed
    
    func loadFileList () {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentPath.appendingPathComponent("lyrics.txt")
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
        let filePath = documentPath.appendingPathComponent("\(name).txt")
        do {
            let content = try String(contentsOf: filePath, encoding: .utf8)
            self.lyrics = content
            self.file_name = name
            self.show_sheet.toggle()
        }
        catch {
            print("Error!")
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.file_list, id: \.self) { file in
                    Button(action: {
                        self.getContent(name: file)
                    }) {
                        Text(file)
                    }
                }
            }
        }
        .onAppear() {
            self.loadFileList()
        }
    }
    
}

//struct ScoresView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoresView()
//    }
//}
