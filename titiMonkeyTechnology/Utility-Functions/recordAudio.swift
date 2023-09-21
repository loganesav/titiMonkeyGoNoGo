//
//  recordAudio.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 5/17/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation
import AVFoundation

class audioRecorder {
    
    let userFiles : userFileManager
    var audioRecorder : AVAudioRecorder?
    var isRecording : Bool

    init(subjectID: String, sessionStamp: String) {
        self.userFiles = userFileManager(name: subjectID, sessionStamp: sessionStamp)
        self.isRecording = false
    }
    
    func startRecording(trialNumber: UInt32) {
        //1. create the session
        let session = AVAudioSession.sharedInstance()
        
        do {
            // 2. configure the session for recording and playback
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            // 3. set up a high-quality recording session
            let settings = [
                AVFormatIDKey: kAudioFormatAppleLossless,
                AVSampleRateKey: 384000,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
                ] as [String : Any]
            // 4. create the audio recording, and assign ourselves as the delegate
            self.audioRecorder = try AVAudioRecorder(url: (self.userFiles.sessionDirectoryPath?.appendingPathComponent(String(trialNumber)).appendingPathExtension("m4a"))!, settings: settings)
            audioRecorder?.delegate = self as? AVAudioRecorderDelegate
            audioRecorder?.record()
            
            //5. Changing record icon to stop icon
            self.isRecording = true
        }
        catch let error {
            // failed to record!
        }
    }
    
    func finishRecording() {
        self.audioRecorder?.stop()
        self.isRecording = false
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.finishRecording()
        }else {
            // Recording interrupted by other reasons like call coming, reached time limit.
        }
    }

        
}
