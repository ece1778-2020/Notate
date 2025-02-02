//
//  MainMenu.swift
//  Notate
//
//  Created by Artorias on 2020-03-04.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI

struct MainMenu: View {
    @State var navigationBarIsHidden: Bool = true
    
    init () {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height:100)
                
                
                Text("NOTATE")
                    .font(Font.system(size: 60))
                    .foregroundColor(.white)
                
                Spacer()
                    .frame(height: 70)
                
                NavigationLink(destination: BPMSelectView(timerhelper: TimerHelper(), navigationBarIsHidden: self.$navigationBarIsHidden)) {
                    Text("Metronome")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                        .padding()
                        .shadow(radius: 10)
                }
                
                NavigationLink(destination: LyricsView(navigationBarIsHidden: self.$navigationBarIsHidden)) {
                    Text("Lyrics")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                        .padding()
                        .shadow(radius: 10)
                }
                
                NavigationLink(destination: RhythmDectView(audioRecorder: AudioRecorder(), navigationBarIsHidden: self.$navigationBarIsHidden)) {
                    Text("Record a song")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                        .padding()
                        .shadow(radius: 10)
                }
                
                NavigationLink(destination: BrowseView()) {
                    Text("Scores")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
                        .padding()
                        .shadow(radius: 10)
                }
                
//                NavigationLink(destination: SheetView(navigationBarIsHidden: self.$navigationBarIsHidden)) {
//                    Text("Sheet Music")
//                        .font(.subheadline)
//                        .frame(maxWidth: .infinity)
//                        .foregroundColor(Color.white)
//                        .padding()
//                        .background(Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255))
//                        .padding()
//                        .shadow(radius: 10)
//                }
                
                
                Spacer()
                .frame(height: 200)
            }
            .background(
            Image("background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
            )
            
                
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .navigationBarTitle("Menu", displayMode: .inline)
        .navigationBarHidden(navigationBarIsHidden)
        .onAppear() {
            self.navigationBarIsHidden = true
        }
            
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
    }
}
