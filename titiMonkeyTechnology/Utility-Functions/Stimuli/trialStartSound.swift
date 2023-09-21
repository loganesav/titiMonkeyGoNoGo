//
//  trailStartSound.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 8/21/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation
import AVFoundation

class trialStartSound {
    var audioPlayer : AVAudioPlayer!
    let soundURL = Bundle.main.url(forResource: "trialStartSound", withExtension: "wav")
    
    init() {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
    }
    
    func play() {
        self.audioPlayer.play()
    }
}
