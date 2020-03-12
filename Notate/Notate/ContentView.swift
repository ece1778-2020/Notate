//
//  ContentView.swift
//  Notate
//
//  Created by Yilun Huang on 2020-02-04.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        MainMenu()
        TimerView(timerhelper: TimerHelper())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
