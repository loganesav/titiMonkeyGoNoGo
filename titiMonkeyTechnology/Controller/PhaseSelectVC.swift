//
//  PhaseSelectVC.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 5/29/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import UIKit

class PhaseSelectVC: UIViewController {
    @IBOutlet weak var goSignalTraining: UIButton!
    @IBOutlet weak var waitScreenTraining: UIButton!
    @IBOutlet weak var alternatingStopSignalTraining: UIButton!
    @IBOutlet weak var randomStopSignalTraining: UIButton!
    @IBOutlet weak var experiment: UIButton!
    
    // Subject object recieved from SubjectSelectVC
    var subject : Subject!
    var phase : SessionConstants.Phase!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Pressing a button in view sets the phase variable then segues
    @IBAction func goSignalTrainingSelected(_ sender: Any) {
        self.phase = SessionConstants.Phase.goSignalTraining
        self.performSegue(withIdentifier: "goToConfirmationScreen", sender: nil)
    }
    
    @IBAction func waitScreenTrainingSelected(_ sender: Any) {
        self.phase = SessionConstants.Phase.waitScreenTraining
        self.performSegue(withIdentifier: "goToConfirmationScreen", sender: nil)
    }
    
    @IBAction func alternatingStopSignalTrainingSelected(_ sender: Any) {
        self.phase = SessionConstants.Phase.alternatingStopSignalTraining
        self.performSegue(withIdentifier: "goToConfirmationScreen", sender: nil)
    }
    
    @IBAction func randomStopSignalTrainingSelected(_ sender: Any) {
        self.phase = SessionConstants.Phase.randomStopSignalTraining
        self.performSegue(withIdentifier: "goToConfirmationScreen", sender: nil)
    }
 
    @IBAction func experimentSelected(_ sender: Any) {
        self.phase = SessionConstants.Phase.experiment
        self.performSegue(withIdentifier: "goToConfirmationScreen", sender: nil)
    }
    
    // Before performing segue, construct a session constants object from selected subject and
    // phase, then pass it into the ConfirmationVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let confVC = segue.destination as? ConfirmationVC else {return}
        confVC.constants = SessionConstants(subject: self.subject,
                                            phase: self.phase)
    }
}
