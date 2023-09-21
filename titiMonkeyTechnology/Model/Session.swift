//
//  SessionResults.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 4/14/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation

class Session {
    let constants: SessionConstants
    var timeOutTimer: Timer
    var trial: Trial
    
    init(constants: SessionConstants) {
        self.constants = constants
        self.timeOutTimer = Timer()
        self.trial = Trial(constants: constants)
    }
    
    func end() {
        self.timeOutTimer.invalidate()
        self.trial.timeOutTimer.invalidate()
    }
    
    func secondsUntilTimeOut() -> Double {
        return self.timeOutTimer.fireDate.timeIntervalSinceNow
    }
}



