//
//  SubjectDataVC.swift
//  titiMonkeyTechnology
//
//  Created by logan savidge on 8/21/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import UIKit
import Foundation

class SubjectDataVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    var constants = readConstantsFromFile()
    
    @IBOutlet weak var subjectIDPickerView: UIPickerView!
    
    // Initialize subject data
    var subjectData = readSubjectDataFromFile()
    var subjectIDs = [String]()
    var selectedSubjectID: String = ""
    var selectedSubject: Subject!
    
    
    @IBOutlet weak var subjectIDCurrent: UILabel!
    @IBOutlet weak var subjectIDField: UITextField!
    @IBOutlet weak var subjectConditionCurrent: UILabel!
    @IBOutlet weak var subjectConditionField: UITextField!
    
    override func viewDidLoad() {
        for subject in subjectData {
            subjectIDs.append(subject.id)
        }
        subjectIDPickerView.delegate = self
        subjectIDPickerView.dataSource = self
        
        super.viewDidLoad()
        
        self.loadPickerViewData()

    }
    
    // SubjectID Pickerview related functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectData[row].id
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSubject = subjectData[row]
        
        updateCurrentSubject(ID: selectedSubject.id, condition: selectedSubject.condition)
    }
    
    func updateCurrentSubject(ID: String, condition: String) {
        // Load currently selected subject's ID and condition into the display fields
        self.subjectIDCurrent.text = ID
        self.subjectConditionCurrent.text = condition
    }
    
    func loadPickerViewData() {
        self.subjectData = readSubjectDataFromFile()
        self.selectedSubject = subjectData[0]
        self.subjectIDs = [String]()
        for subject in subjectData {
            subjectIDs.append(subject.id)
        }
        self.subjectIDPickerView.reloadAllComponents()
    }
    
    @IBAction func subjectDataUpdate(_ sender: Any) {
        // Attempt to change the slected subject's ID/condition
        if self.validatesubjectID(subjectID: self.subjectIDField.text!) {
            let updateSubject = Subject(id: self.subjectIDField.text!,
                                        condition: self.subjectConditionField.text!,
                                        diameter: self.selectedSubject.diameter)
            writeSubjectDataToFile(data: updateSubject, replace: true, source: self.subjectIDCurrent.text!)
            self.loadPickerViewData()
        }
    }
    
    func validatesubjectID(subjectID: String) -> Bool {
        // Require subject id's to be a minimum of 3 characters
        if subjectID.count < 4 {
            return false
        }
        
        // Cannot change ID to that of an existing subject
        if self.subjectIDs.contains(subjectID) && subjectID != self.subjectIDCurrent.text! {
            return false
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
