//
//  button.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 5/17/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation

class Button {
    
    // Enum encoding possible button states
    enum State :Int {
        case wait       = 0 // Waiting for subject to initiate a trial
        case hold       = 1 // Subject holding between initiating trial and seeing a signal
        case response   = 2 // Signal has been displayed, waiting for subject's response
        case disabled   = 3 // Temporary state where button press does nothing
        case lock       = 4 // Permenant disabled state, once locked button can not be unlocked
    }
    
    var currentState : State

    init() {
        self.currentState = State.disabled
    }
    
    func disableButtons() {
        if self.currentState != State.lock {
            self.currentState = State.disabled
        }
    }

    func setHold() {
        self.disableButtons()
        if self.currentState != State.lock {
            self.currentState = .hold
        }
    }
    
    func setWait() {
        self.disableButtons()
        if self.currentState != State.lock {
            self.currentState = .wait
        }
    }
    
    func setResponse() {
        self.disableButtons()
        if self.currentState != State.lock {
            self.currentState = .response
        }
    }
    
    func setLock() {
        self.currentState = .lock
    }
}
