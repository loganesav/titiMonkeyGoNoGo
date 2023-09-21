//
//  ConfirmationVC.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 5/29/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import UIKit

class ConfirmationVC: UIViewController {
    
    @IBOutlet weak var holdPhaseDelayLabel: UILabel!
    @IBOutlet weak var positiveDelayLabel: UILabel!
    @IBOutlet weak var negativeDelayLabel: UILabel!
    @IBOutlet weak var subjectIDLabel: UILabel!
    @IBOutlet weak var subjectConditionLabel: UILabel!
    @IBOutlet weak var phaseNumberLabel: UILabel!
    @IBOutlet weak var sessionTimeLabel: UILabel!
    
    // Session Constants object recieved from last view controller
    var constants: SessionConstants!
    var session: Session!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Construct a session object using the recieved constants
        self.session = Session(constants: constants)
        
        // Display details from constants file in appropiate label on view
        self.subjectIDLabel.text = "Subject ID: \(self.constants.subject.id)"
        self.subjectConditionLabel.text = "Subject Condition: \(self.constants.subject.condition)"
        self.phaseNumberLabel.text = "Phase: \(self.constants.phase)"
        self.negativeDelayLabel.text = "Negative reinforcement delay: \(self.constants.negativeReinforcementDelay)"
        self.positiveDelayLabel.text = "Positive reinforcement delay: \(self.constants.positiveReinforcementDelay)"
        self.holdPhaseDelayLabel.text = "Hold phase delay: \(self.constants.holdPhaseDelay)"
        self.sessionTimeLabel.text = "Session timout time: \(self.constants.sessionTimeoutTime)"
    }
    
    // Before segueing to SessionVC on "confirmation" initialize the view controller
    // with the construction session object
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sessionVC = segue.destination as? SessionVC else {return}
        sessionVC.session = self.session
    }
    
    // Return to SubjectSelectVC if cancel button is selected
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "goBackToMain", sender: self)
    }
    
}
