//
//  AdminVC.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 8/13/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import UIKit
import Foundation

class AdminVC: UIViewController, UITextFieldDelegate  {
    var constants = readConstantsFromFile()
    
    @IBOutlet weak var negativeReinforcementDelayCurrent: UILabel! // Display current value
    @IBOutlet weak var negativeReinforcementDelayField: UITextField! // Input text box
    @IBOutlet weak var negativeReinforcementDelayButton: UIButton! // Replace current with input
    
    @IBOutlet weak var positiveReinforcementDelayCurrent: UILabel!
    @IBOutlet weak var positiveReinforcementDelayField: UITextField!
    @IBOutlet weak var positiveReinforcementDelayButton: UIButton!

    @IBOutlet weak var holdPhaseDelayCurrent: UILabel!
    @IBOutlet weak var holdPhaseDelayField: UITextField!
    @IBOutlet weak var holdPhaseDelayButton: UIButton!

    @IBOutlet weak var sessionTimeoutTimeCurrent: UILabel!
    @IBOutlet weak var sessionTimeoutTimeField: UITextField!
    @IBOutlet weak var sessionTimeoutTimeButton: UIButton!
    
    @IBOutlet weak var stopStimulusDurationCurrent: UILabel!
    @IBOutlet weak var stopStimulusDurationField: UITextField!
    @IBOutlet weak var stopStimulusDurationButton: UIButton!
     
    @IBOutlet weak var goStimulusDurationCurrent: UILabel!
    @IBOutlet weak var goStimulusDurationField: UITextField!
    @IBOutlet weak var goStimulusDurationButton: UIButton!
    
    @IBOutlet weak var maxRepeatsCurrent: UILabel!
    @IBOutlet weak var maxRepeatsField: UITextField!
    @IBOutlet weak var maxRepeatsButton: UIButton!
    

    override func viewDidLoad() {
        self.displayCurrentConstants()
    }
    

    func displayCurrentConstants() {
        // Load constants from file
        constants = readConstantsFromFile()
        
        // If constant exists in file use file's vale, otherwise (??) use the provided default
        self.negativeReinforcementDelayCurrent.text = "\(constants["negativeReinforcementDelay"] ?? 3.0)"
        self.positiveReinforcementDelayCurrent.text = "\(constants["positiveReinforcementDelay"] ?? 1.0)"
        self.holdPhaseDelayCurrent.text = "\(constants["holdPhaseDelay"] ?? 1.5)"
        self.sessionTimeoutTimeCurrent.text = "\(constants["sessionTimeoutTime"] ?? 480)"
        self.stopStimulusDurationCurrent.text = "\(constants["stopStimulusDuration"] ?? 1.0)"
        self.goStimulusDurationCurrent.text = "\(constants["goStimulusDuration"] ?? 30)"
        self.maxRepeatsCurrent.text = "\(constants["maxRepeats"] ?? 4)"
    }

    @IBAction func negativeReinforcementDelayUpdate(_ sender: Any) {
        // Load value from text field, if no value is present assign to nil
        let update = Double(self.negativeReinforcementDelayField.text!) ?? nil
        if update != nil {
            writeConstantToFile(variableName: "negativeReinforcementDelay", assign: update!)
            self.displayCurrentConstants()
        }
    }
    
    @IBAction func positiveReinforcementDelayUpdate(_ sender: Any) {
        let update = Double(self.positiveReinforcementDelayField.text!) ?? nil
        if update != nil {
            writeConstantToFile(variableName: "positiveReinforcementDelay", assign: update!)
            self.displayCurrentConstants()
        }
    }
    
    @IBAction func holdPhaseDelayUpdate(_ sender: Any) {
        let update = Double(self.holdPhaseDelayField.text!) ?? nil
        if update != nil {
            writeConstantToFile(variableName: "holdPhaseDelay", assign: update!)
            self.displayCurrentConstants()
        }
    }
    
    @IBAction func sessionTimeoutTimeUpdate(_ sender: Any) {
        let update = Double(self.sessionTimeoutTimeField.text!) ?? nil
        if update != nil {
            writeConstantToFile(variableName: "sessionTimeoutTime", assign: update!)
            self.displayCurrentConstants()
        }
    }
    
    @IBAction func stopStimulusDurationUpdate(_ sender: Any) {
        let update = Double(self.stopStimulusDurationField.text!) ?? nil
        if update != nil {
            writeConstantToFile(variableName: "stopStimulusDuration", assign: update!)
            self.displayCurrentConstants()
        }
    }
    
    @IBAction func goStimulusDurationUpdate(_ sender: Any) {
        let update = Double(self.goStimulusDurationField.text!) ?? nil
        if update != nil {
            writeConstantToFile(variableName: "goStimulusDuration", assign: update!)
            self.displayCurrentConstants()
        }
    }
    
    @IBAction func maxRepeatsUpdate(_ sender: Any) {
        let update = Double(self.maxRepeatsField.text!) ?? nil
        if update != nil {
            writeConstantToFile(variableName: "maxRepeats", assign: update!)
            self.displayCurrentConstants()
        }
    }


}
