//
//  SessionConstants.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 5/23/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation

class SessionConstants {
    
    // Enum used to handle phases
    enum Phase :Int {
        case goSignalTraining                   = 0 //= "Go Signal Training"
        case waitScreenTraining                 = 1 //= "Wait Screen Training"
        case alternatingStopSignalTraining      = 2 //= "Alternating Stop Signal Training"
        case randomStopSignalTraining           = 3 //= "Random Stop Signal Training"
        case experiment                         = 4 //= "Eperiment"
    }
    
    let subject : Subject
    let phase: Phase
    let stopStimulusDuration : Float64 // Length of a stop stimulus trial
    let goStimulusDuration : Float64
    let negativeReinforcementDelay : Float64 // Delay imposed after undesired behavior
    let positiveReinforcementDelay : Float64 // Delay imposed after desired behavior
    let holdPhaseDelay : Float64 // Amount of time between trial start tone and signal display
    let sessionTimeoutTime : Float64 // Length of a session
    let maxRepeats : UInt8 // Max number of times a random event can repeat
    let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    
    let sessionStartTimeStamp : dateTimeStamp // Time the session started

    // Initialize object providng default values
    init(subject: Subject,
         phase: Phase,
         stopStimulusDuration: Float64 = 1.0,
         goStimulusDuration: Float64 = 30.0,
         negativeReinforcementDelay: Float64 = 3.0,
         positiveReinforcementDelay: Float64 = 1.0,
         holdPhaseDelay: Float64 = 1.5,
         sessionTimeoutTime: Float64 = 8 * 60,
         maxRepeats: Float64 = 4
        
         ) {
        
        let constantsDict = readConstantsFromFile()

        self.subject = subject
        self.phase = phase
        
        // If variable not set in the constants file, use the provided default value
        self.stopStimulusDuration = constantsDict["stopStimulusDuration"] ?? stopStimulusDuration
        self.goStimulusDuration = constantsDict["goStimulusDuration"] ?? goStimulusDuration
        self.negativeReinforcementDelay = constantsDict["negativeReinforcementDelay"] ?? negativeReinforcementDelay
        self.positiveReinforcementDelay = constantsDict["positiveReinforcementDelay"] ?? positiveReinforcementDelay
        self.holdPhaseDelay = constantsDict["holdPhaseDelay"] ?? holdPhaseDelay
        self.sessionTimeoutTime = constantsDict["sessionTimeoutTime"] ?? sessionTimeoutTime
        self.maxRepeats = UInt8(constantsDict["maxRepeats"] ?? maxRepeats)
        self.sessionStartTimeStamp = dateTimeStamp(stampedTime: Date())
    }
    
    func write() {
        writeSessionConstantsToFile(data: formatConstantsString())
    }
    
    func formatConstantsString() -> String {
        var constantsString = "\n"
        constantsString += self.sessionStartTimeStamp.timeStampString + ","
        constantsString += self.subject.id + ","
        constantsString += self.subject.condition + ","
        constantsString += String(self.phase.rawValue) + ", "
        constantsString += String(self.goStimulusDuration) + ", "
        constantsString += String(self.stopStimulusDuration) + ", "
        constantsString += String(self.negativeReinforcementDelay) + ","
        constantsString += String(self.positiveReinforcementDelay) + ","
        constantsString += String(self.holdPhaseDelay) + ","
        constantsString += String(self.sessionTimeoutTime) + ","
        constantsString += self.version + "." + self.build
        
        return constantsString
    }
}
