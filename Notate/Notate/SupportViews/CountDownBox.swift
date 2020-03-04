//
//  CountDownBox.swift
//  Notate
//
//  Created by Yilun Huang on 2020-03-04.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import SwiftUI

struct CountDownBox: View {
    @State var timeRemaining = 10
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        Text("\(timeRemaining)")
        .onReceive(timer) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }

    }
}

struct CountDownBox_Previews: PreviewProvider {
    static var previews: some View {
        CountDownBox()
    }
}
