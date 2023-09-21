//
//  AdminPasswordVC.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 9/8/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import UIKit

class AdminPasswordVC: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitPassword(_ sender: Any) {
        // If the password field is not empty and equals to TitiC0d3! go to the AdminVC
        if !((self.passwordField.text?.isEmpty)!) && self.passwordField.text! == "TitiC0d3!" {
            self.performSegue(withIdentifier: "goToAdmin", sender: nil)
        // Otherwise return to SubjectSelectVC
        } else {
            let StoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : UIViewController = StoryBoard.instantiateViewController(withIdentifier: "SubjectSelect")
            self.present(vc, animated: false)
        }
    }

}
