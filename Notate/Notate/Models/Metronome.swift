//
//  Metronome.swift
//  Notate
//
//  Created by Artorias on 2020-02-06.
//  Copyright © 2020 Yilun Huang. All rights reserved.
//

import Foundation
import AVFoundation

class Metronome {
    var audioPlayer: AVAudioPlayer?
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            }
            catch {
                print("File not found")
            }
        }
    }
}



