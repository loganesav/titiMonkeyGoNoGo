//
//  Trial.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 4/15/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation

class Trial {
    var touched : Bool // Response touch occured?
    var timeOutTimer : Timer // Time until trial times out
    var holdStateTouchCounter : UInt32 // Number of screen touches in the hold state
    var stimulusHistory : [Bool] // Stores trial types for previous trials
    var responseTimeTimer : precisionTimer // Time between trial start and screen touch
    var displayStopStimulus : Bool // False = goStimulus True = stopStimulus
    var trialNumber : UInt32 // Incremented every trial
    var hit : Bool // Was the touch on the actual go signal?
    
    let constants: SessionConstants
    
    init(constants: SessionConstants) {
        self.touched = false
        self.timeOutTimer = Timer()
        self.holdStateTouchCounter = 0
        self.stimulusHistory = []
        self.responseTimeTimer = precisionTimer()
        self.displayStopStimulus = false
        self.trialNumber = 0
        self.hit = false
        
        // Local copy of SessionConstants object
        self.constants = constants

    }
    
    func end() {
        let data = self.formatDataLine()
        writeTrialDataToFile(data: data)
    }
    
    func new() {
        self.trialNumber += 1
        self.touched = false
        self.holdStateTouchCounter = 0
        self.setStimulus()
        self.hit = false
    }
    
    func setStimulus() {
        switch self.constants.phase {
        case .goSignalTraining:
            self.displayStopStimulus = false
        case .waitScreenTraining:
            self.displayStopStimulus = false
        case .alternatingStopSignalTraining:
            self.displayStopStimulus = !self.displayStopStimulus
        case .randomStopSignalTraining:
            self.displayStopStimulus = self.getRandomStimulus()
        case .experiment:
            break
        default:
            print("ERROR, INVALID PHASE: \(self.constants.phase)")
        }
    }
    
    private func getRandomStimulus() -> Bool {
        var stimulus = arc4random_uniform(2) == 1 ? true : false
        
        if stimulus == self.stimulusHistory.last {
            self.stimulusHistory.append(stimulus)
        } else {
            self.stimulusHistory.removeAll()
        }
        
        if self.stimulusHistory.count == self.constants.maxRepeats {
            stimulus = !stimulus
            self.stimulusHistory.removeAll()
        }
        
        return stimulus
    }
    
    // id,condition,timeStamp,phase,trialNumber,trialType,screenTouched,responseTime,
    // holdStateTouchCounter,hit,diameter
    func formatDataLine() -> String {
        var dataLine = "\n"
        dataLine += self.constants.subject.id + ","
        dataLine += self.constants.subject.condition + ","
        dataLine += self.constants.sessionStartTimeStamp.timeStampString + ","
        dataLine += String(self.constants.phase.rawValue) + ","
        dataLine += String(self.trialNumber) + ","
        dataLine += (self.displayStopStimulus ? "TRUE," : "FALSE,")
        dataLine += (self.touched ? "TRUE," : "FALSE,")
        dataLine += String(self.responseTimeTimer.milliseconds) + ","
        dataLine += String(self.holdStateTouchCounter) + ","
        dataLine += (self.hit ? "TRUE" : "FALSE") + ","
        dataLine += String(self.constants.subject.diameter)
        
        print(dataLine)
        return dataLine
    }
}
