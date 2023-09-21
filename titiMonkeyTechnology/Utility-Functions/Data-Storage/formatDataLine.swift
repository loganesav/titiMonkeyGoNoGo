//
//  writeTrialData.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 5/2/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation

// id | condition | session stamp | Trial # | Stop Signal (bool) | Screen Touched (bool) | Responce Time (seconds) | # of false presses
func formatDataLine(subjectID: String, sessionStamp: String, trialNumber: UInt16, stopSignal: Bool, screenTouched: Bool, responceTime: Double, touchCounter: UInt8) -> String {
    var dataLine = "\n"
    dataLine += subjectID + ", "
    dataLine += "UNKNOWN, "
    dataLine += sessionStamp + ", "
    dataLine += String(trialNumber) + ", "
    dataLine += (stopSignal ? "TRUE, " : "FALSE, ")
    dataLine += (screenTouched ? "TRUE, " : "FALSE, ")
    dataLine += String(responceTime) + ", "
    dataLine += String(touchCounter)
    
    return dataLine
}
