//
//  SubjectSelectVC.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 4/17/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import UIKit
import Foundation

class SubjectSelectVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var pickerViewer: UIPickerView!
    @IBOutlet weak var addSubjectID: UITextField!
    @IBOutlet weak var addSubjectCondition: UITextField!
        
    var subjectData = readSubjectDataFromFile()
    var subjectIDs = [String]()
    var selectedSubjectID: String = ""
    
    
    override func viewDidLoad() {
        pickerViewer.delegate = self
        pickerViewer.dataSource = self
        
        super.viewDidLoad()
        
        for subject in subjectData {
            subjectIDs.append(subject.id)
        }
        
        // If no subjects were loaded from file use an empty string subject id
        if self.selectedSubjectID.count == 0 {
            self.selectedSubjectID = ""
        } else {
            self.selectedSubjectID = self.subjectIDs[0] // Default subjectID
        }
        
        self.addSubjectID.delegate = self
        self.addSubjectCondition.delegate = self
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectIDs.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectIDs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedSubjectID = subjectIDs[row]
    }
    
    func validatesubjectID(subjectID: String) -> Bool {
        if subjectID.count < 4 {
            return false
        }
        
        if self.subjectIDs.contains(String(subjectID)) {
            return false
        }

        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addSubject(_ sender: Any) {
        // Attempt to add a new subject to file, conditional on providing a valid subjectID.
        let ID : String = addSubjectID.text!
        let condition : String = addSubjectCondition.text!
        
        // Instantiate a Subject struct with provided ID/Condition values and max diameter size
        // for shrinkingGo phase.
        let subject = Subject(id: ID, condition: condition, diameter: 762)
        
        if validatesubjectID(subjectID: ID) {
            writeSubjectDataToFile(data: subject)
            
            // Add new subject to the list of ID's used by the picker wheel
            self.subjectIDs.append(ID)
            self.pickerViewer.reloadAllComponents()
            self.subjectData.append(subject)
        } else {
            print("\(ID) is not a valid subjectID")
        }
    }
    
    // Prior to preforming a segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If the destination view controller is PhaseSelectVC
        guard let menuVC = segue.destination as? PhaseSelectVC else {return}
        
        // Check for an empty subject ID. This case handles the event that no subject existed at
        // the start. If no subjects were created the app will crash, otherwise the first subject
        // will be auto selected.
        if self.selectedSubjectID == "" {
            self.selectedSubjectID = self.subjectIDs[0]
        }
        
        // Load the subject object based on the selected subjects id
        var selectedSubject : Subject!
        for subject in subjectData {
            if subject.id  == selectedSubjectID {
                selectedSubject = subject
            }
        }
        
        // Pass the selected subject to the next view controller
        menuVC.subject = selectedSubject
    }
}
