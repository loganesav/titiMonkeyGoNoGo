//
//  writeToFile.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 4/16/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation

func writeToFile(text: Int, file: String) {
 /*   if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        let fileURL = dir.appendingPathComponent(file)
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }

        
        //writing
        do {
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                fileHandle.seekToEndOfFile()
                fileHandle.write(text.data(using: .utf8)!)
                fileHandle.closeFile()
            } catch {
                print("Error writing to file \(error)")
        }

        //reading
        /*
        do {
            let text2 = try String(contentsOf: fileURL, encoding: .utf8)
            print(text2)
        }
        catch {/* error handling here */}
        */
    }*/
}


