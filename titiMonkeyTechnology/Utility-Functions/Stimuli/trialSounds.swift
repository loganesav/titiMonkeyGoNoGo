//
//  trialSounds.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 8/21/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation
import AVFoundation

class trialSounds {
    var clickAudioPlayer : AVAudioPlayer!
    var trialStartAudioPlayer : AVAudioPlayer!
    var negativeReinforcementAudioPlayer : AVAudioPlayer!
    
    let clickSoundURL = Bundle.main.url(forResource: "clickSound", withExtension: "caf")
    let trialStartSoundURL = Bundle.main.url(forResource: "trialStartSound", withExtension: "wav")
    let negativeSoundURL = Bundle.main.url(forResource: "negativeReinforcement", withExtension: "wav")


    
    init() {
        do {
            // Load the audio players with the appropiate audio file
            self.clickAudioPlayer = try AVAudioPlayer(contentsOf: clickSoundURL!)
            self.trialStartAudioPlayer = try AVAudioPlayer(contentsOf: trialStartSoundURL!)
            self.negativeReinforcementAudioPlayer = try AVAudioPlayer(contentsOf: negativeSoundURL!)
            
            // Adjust volume of audio players
            self.trialStartAudioPlayer.volume = 0.05
            self.negativeReinforcementAudioPlayer.volume = 0.5
        }
        catch {
            print(error)
        }
    }
    
    // Play click sound, repeating nTimes
    func playClick(nTimes: Int = 0) {
        self.clickAudioPlayer.numberOfLoops = nTimes
        self.clickAudioPlayer.play()
    }
    
    func playTrialStart() {
        self.trialStartAudioPlayer.play()
    }
    
    func playNegative() {
        self.negativeReinforcementAudioPlayer.play()
    }
}
