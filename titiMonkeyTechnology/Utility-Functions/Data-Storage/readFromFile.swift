//
//  readFromFile.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 4/16/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation

func readFromFile(wtf: String) -> String {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        let fileURL = dir.appendingPathComponent(wtf)
        
        //reading
        do {
            let text = try String(contentsOf: fileURL, encoding: .utf8)
            return text
        }
        catch {/* error handling here */}
    }
    return ""
}
