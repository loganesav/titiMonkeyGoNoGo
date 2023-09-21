//
//  shrinkingGoSignalVC.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 8/15/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import UIKit

class shrinkingGoSignalVC: UIViewController {
    var sounds = trialSounds()
    var session: Session!
    
    // Disable touches for a period of time between presses
    var touchLockTimer: Timer!
    var touchLock : Bool = false
    
    func setTouchLockTimer() {
        self.touchLock = true
        self.touchLockTimer = Timer.scheduledTimer(
            timeInterval: 0.25,
            target: self,
            selector: #selector(self.touchLockTimerAction),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc func touchLockTimerAction() {
        self.touchLock = false
    }

    @IBOutlet weak var goSignalImage: UIImageView!
    
    // Track the number of succesful / failed touches
    var success_counter = 0
    var fail_counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.session.trial.new()
        
        let shrinkNum : Int = (762 - self.session.constants.subject.diameter) / 20
        for _ in 0...shrinkNum {
            self.shrink()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Increase the diameter of the goSignalImage
    func grow() {
        let current_diameter = self.goSignalImage.frame.size.width
        
        // If current diameter is greater then or equal to 762, do not increase image diameter
        if current_diameter < 762 {
            let new_diameter = current_diameter + 20
            let new_x = self.goSignalImage.frame.minX - 10
            let new_y = self.goSignalImage.frame.minY - 10
            
            self.goSignalImage.frame = CGRect(
                x: new_x, y: new_y, width: new_diameter, height: new_diameter)
            self.goSignalImage.layer.cornerRadius = self.goSignalImage.frame.width / 2
        }
        
        self.fail_counter = 0
    }
    
    // Shrink the diameter of the goSignalImage
    func shrink() {
        let current_diameter = self.goSignalImage.frame.size.width
        if current_diameter > 400 {
            let new_diameter = current_diameter - 20
            let new_x = self.goSignalImage.frame.minX + 10
            let new_y = self.goSignalImage.frame.minY + 10
            
            self.goSignalImage.frame = CGRect(
                x: new_x, y: new_y, width: new_diameter, height: new_diameter)
            self.goSignalImage.layer.cornerRadius = self.goSignalImage.frame.width / 2
        }
        self.success_counter = 0
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
        var subject = self.session.constants.subject
        subject.diameter = Int(self.goSignalImage.frame.width)
        writeSubjectDataToFile(data: subject, replace: true, source: subject.id)
        self.session.end()
        self.performSegue(withIdentifier: "goToMenu", sender: nil)
        }
    }
    
    // Intercept touches on the screen and interpret the result
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            // If the view is shrinkingGoSignal and the touchLock is not active
            if touch.view == self.view && self.touchLock == false {
                let position = touch.location(in: view)
                let radius = self.goSignalImage.frame.width / 2
                let distance = sqrt(
                    pow((position.y - view.center.y), 2) + pow((position.x - view.center.x), 2))
                if distance > radius {
                    self.session.trial.hit = false
                    sounds.playNegative()
                    self.fail_counter = self.fail_counter + 1
                    self.success_counter = 0
                } else {
                    self.session.trial.hit = true
                    sounds.playClick()
                    self.success_counter = self.success_counter + 1
                    self.fail_counter = 0
                }
                
                if self.fail_counter == 3 {
                    self.grow()
                } else if self.success_counter == 3 {
                    self.shrink()
                }
                self.session.trial.end()
                self.session.trial.new()
                self.setTouchLockTimer()
            }
        }
    }
    
    // Disable the session object to prevent any additional data recording after the session ends
    override func viewWillDisappear(_ animated: Bool) {
        self.session = nil
    }
}
