//
//  SessionVC.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 4/12/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import UIKit
import Foundation

class SessionVC: UIViewController {
    
    
    @IBOutlet weak var signalImageLHS: UIImageView!
    @IBOutlet weak var signalImageRHS: UIImageView!
    
    // Logic interpreting screen touches based on current state of the experiment
    var buttonHandler = Button()
    var session: Session!
    
    let goSignalImage = UIImage(named: "goSignal3")
    let stopSignalImage = UIImage(named: "stopSignal3")
    
    let sounds = trialSounds()
    
    var experimentTrialType: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if session.constants.phase == .experiment {
            /* For experiment phase start by appending 60 elements to a list with 48
             elements being false and 12 being true. During the session true will signal
             a no-go trial while false will signal a go trial. */
            for _ in 1...48 {
                experimentTrialType.append(false)
            }
            
            for _ in 1...12 {
                experimentTrialType.append(true)
            }
            // Randomize the list using builting shuffle()
            experimentTrialType.shuffle()
        }
        self.session.timeOutTimer = Timer.scheduledTimer(
            timeInterval: (self.session.constants.phase == .experiment) ? 24 * 60 * 60 : self.session.constants.sessionTimeoutTime,
            target: self,
            selector: #selector(self.sessionTimerAction),
            userInfo: nil,
            repeats: false
        )
        
        
        self.session.constants.write()
        print("Constants: \(self.session.constants.formatConstantsString())")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // If the selected phase is goSignalTraining navigate to the shrinkingGoSignalVC
        // otherwise call the wait screen.
        if session.constants.phase == .goSignalTraining {
            self.performSegue(withIdentifier: "goToShrinkingGoSignal", sender: nil)
        } else {
            self.waitScreen(holdOnWaitScreen: 1)
        }
    }
    
    
    // Blank screen between trials. Recieves a time in the "holdOnWaitScreen" parameter to wait
    // prior to calling the goSignal() function
    func waitScreen(holdOnWaitScreen: Float64) {
        
        self.session.trial.timeOutTimer.invalidate()
        self.buttonHandler.disableButtons()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + holdOnWaitScreen) {
            if self.session != nil {
                self.startTrial()
            }
        }
    }
    
    // Trial starting point
    func startTrial() {
        // If the session will end before the maximum length of a trial, manually fire the session
        // timeOutTimer and return without initializing trial. If the session phase is experiment
        // this should be skipped, using the short cirtuiting behavior of && in swift.
        if !(self.session.constants.phase == .experiment) && self.session.secondsUntilTimeOut() < 6.0 {
            self.session.timeOutTimer.fire()
            return
        }
        
        if self.experimentTrialType.isEmpty && self.session.constants.phase == .experiment {
            self.session.timeOutTimer.fire()
            return
        }
        
        // Initialize a new trial and play the trial start tone
        self.session.trial.new()
        self.sounds.playTrialStart()
        
        // Set button state to hold, capturing screen touches occuring between trial start sound
        // and the signal actually displaying on screen.
        self.buttonHandler.setHold()
        
        DispatchQueue.main.asyncAfter(
        deadline: .now() + Float64(self.session.constants.holdPhaseDelay)) {
            if self.session != nil {
                self.displaySignal()
            }
        }
        
    }
    
    // Randomly select which side of the screen to display signal and log the appropiate image.
    func displaySignal() {
        
        // For experiment phase the stop stimulus is determined by the experimentTrialType
        // list. Overwrite the constents of displayStopStimulus with this data.
        // List is force unwrapped, application will crash if this list is empty here.
        if self.session.constants.phase == .experiment {
            self.session.trial.displayStopStimulus = experimentTrialType.popLast()!
        }
        // Preform a "coin flip" to determine which side of the screen to display signal
        let goLeft = arc4random_uniform(2) == 1 ? true : false
        if self.session.trial.displayStopStimulus == true {
            if goLeft {
                self.signalImageLHS.image = self.stopSignalImage
            } else {
                self.signalImageRHS.image = self.stopSignalImage
            }
        } else {
            if goLeft {
                self.signalImageLHS.image = self.goSignalImage
            } else {
                self.signalImageRHS.image = self.goSignalImage
            }
        }
        
        // For experiment phase, the stop stimulus is not displayed on its own. Place the go
        // signal image in the other position in this case.
        //if self.session.constants.phase == .experiment && self.session.trial.displayStopStimulus == true {
            //if goLeft {
                //self.signalImageRHS.image = self.goSignalImage
            //} else {
                //self.signalImageLHS.image = self.goSignalImage
           //}
        //}
        
        // Signal is displayed, set the button to expect a response touch
        self.buttonHandler.setResponse()
        
        // Start trial's response time timer
        self.session.trial.responseTimeTimer.Start()
        
        // Set the amount of time for the trial to last before triggering a timout timer
        let timeoutTime =
            (self.session.trial.displayStopStimulus) ? self.session.constants.stopStimulusDuration
                : self.session.constants.goStimulusDuration
        
        // Start the timeout timer using timoutTime as the amount of time for the trial to last
        // without a touch intervening
        self.session.trial.timeOutTimer = Timer.scheduledTimer(
            timeInterval: timeoutTime,
            target: self,
            selector: #selector(self.trialTimerAction),
            userInfo: nil,
            repeats: false
        )
    }
    
    // Track touches on screen and implement "button" behavior
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Load the touch data
        let touch = touches.first!
        
        // Check the currently active view to ensure touches are not intercepted from other views
        if touch.view == self.view {
            
            // Extract the touch position
            let position = touch.location(in: self.view)
            
            // Check if the current trial is a goSignal trial
            if !self.session.trial.displayStopStimulus {
                // Initialize a distance variable to arbitrary large value, will hold distance
                // from center of goSignalImage to the position of the touch
                var distance : CGFloat = CGFloat.greatestFiniteMagnitude
                if self.signalImageLHS.image == self.goSignalImage {
                    distance = sqrt(pow((position.y - signalImageLHS.center.y), 2)
                        + pow((position.x - signalImageLHS.center.x), 2))
                } else {
                    distance = sqrt(pow((position.y - signalImageRHS.center.y), 2)
                        + pow((position.x - signalImageRHS.center.x), 2))
                }
                // If the distance between the appropiate goSignalImage and the touch is less then
                // 250 the touch was on the signal
                if distance < 250 {
                    self.session.trial.hit = true
                } else {
                    self.session.trial.hit = false
                }
            }
            self.evaulateTouch()
        }
    }
    
    func evaulateTouch() {
        // Handle button behavior using a switch statement on the button's currentState
        // and the current trials type (stop or go).
        switch self.buttonHandler.currentState {
        case .wait:
            self.startTrial()
        case .hold:
            self.session.trial.holdStateTouchCounter += 1
        case .response:
            if !self.session.trial.displayStopStimulus && self.session.trial.hit {
                self.sounds.playClick()
            } else {
                if !(self.session.constants.phase == .experiment) {
                    self.sounds.playNegative()
                }
            }
            self.session.trial.touched = true
            self.endOfTrial()
        default:
            break
        }
    }
    // End of trial triggered by timer (rather then a button click)
    @objc func trialTimerAction() {
        
        // If the trial is a stop signal trial
        if self.session.trial.displayStopStimulus {
            self.sounds.playClick()
            self.endOfTrial()
        } else {
            self.endOfTrial()
        }
        
    }
    
    // Tear down trial
    func endOfTrial() {
        self.session.trial.responseTimeTimer.Stop()
        self.session.trial.timeOutTimer.invalidate()
        self.buttonHandler.disableButtons()
        self.signalImageLHS.image = nil
        self.signalImageRHS.image = nil
        
        self.session.trial.end()
        
        self.waitScreen(holdOnWaitScreen: self.determineWaitScreenDelay())
    }
    
    // Decide what delay between trials to load based on current trials collected data.
    func determineWaitScreenDelay() -> Float64 {
        if self.session.trial.displayStopStimulus == true {
            if self.session.trial.touched == true {
                return self.session.constants.negativeReinforcementDelay
            }
        }
        return self.session.constants.positiveReinforcementDelay
    }
    
    /* When the session timer triggers lock down the experiment from all further actions, play
     the clicksound 3 times and set a timer to repeat this action in 10 seconds. Note that by
     invalidating the trial timer and locking the button all paths to calling self.endOfTrial() are
     closed. Once the session timer triggers, no additional data is generated. */
    @objc func sessionTimerAction() {
        // Remove the trial timer, preventing automatic end of trial behavior
        self.session.trial.timeOutTimer.invalidate()
        
        // Remove any signals on screen
        self.signalImageLHS.image = nil
        self.signalImageRHS.image = nil
        
        // Lock the button, preventing any screen touches from triggering events
        self.buttonHandler.setLock()
        
        self.sounds.playClick(nTimes: 4)
        self.session.timeOutTimer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(self.sessionTimerAction),
            userInfo: nil,
            repeats: false)
    }
    
    // Exit the SessionVC using screen shake as a trigger. Make call to session.end() prior to
    // performing segue.
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.session.timeOutTimer.invalidate()
            self.session.trial.timeOutTimer.invalidate()
            self.session = nil
            self.buttonHandler.setLock()
            self.performSegue(withIdentifier: "goToMenu", sender: nil)
        }
    }
    
    // When segueing to the shrinkingGoSignalVC pass the view controller the session object
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is shrinkingGoSignalVC {
            guard let shrinkingVC = segue.destination as? shrinkingGoSignalVC else {return}
            shrinkingVC.session = self.session
        }
    }
}
