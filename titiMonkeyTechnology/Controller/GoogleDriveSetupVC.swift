//
//  GoogleDriveSetupVC.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 9/4/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST

class GoogleDriveSetupVC: UIViewController {
    
    
    fileprivate let service = GTLRDriveService()
    private var drive: GoogleDrive?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Attempty to sign in with stored credentials
        setupGoogleSignIn()
        
        // Instantiate the drive
        self.drive = GoogleDrive(service)
        
        // Add the google drive sign in popup view
        view.addSubview(GIDSignInButton())

    }


    private func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDriveFile]
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    // Upload data to signed in user's google drive
    @IBAction func uploadData(_ sender: Any) {
        if let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let dataFilePath = documentsDir.appendingPathComponent("data.csv").path
            drive?.uploadFile("titiMonkeyData", filePath: dataFilePath, MIMEType: "text/csv") { (fileID, error) in
                print("Upload file ID: \(String(describing: fileID)); Error: \(String(describing: error?.localizedDescription))")
            }
            
            let constantsFilePath = documentsDir.appendingPathComponent("sessionConstants.csv").path
            drive?.uploadFile("titiMonkeyData", filePath: constantsFilePath, MIMEType: "text/csv") { (fileID, error) in
            print("Upload file ID: \(String(describing: fileID)); Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    // Create a new data file by renaming the current data file using an appended time stamp
    @IBAction func newDataFile(_ sender: Any) {
        let dateString = Date().toString(dateFormat: "yy_MM_dd-HH_mm")
        makeNewDataFile(timeStamp: dateString)
    }
    
}

// Google drive in sign in popup view controller
extension GoogleDriveSetupVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            service.authorizer = nil
        } else {
            service.authorizer = user.authentication.fetcherAuthorizer()
        }
    }
}

extension GoogleDriveSetupVC: GIDSignInUIDelegate {}
