//
//  ReadWriteFileManager.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 4/18/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation

struct Subject {
    var id : String
    var condition : String
    var diameter : Int
}


func writeToFile(data: String, fileName: String, overwrite: Bool = false) {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
            let fileURL = dir.appendingPathComponent(fileName)
        
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
            }

        //writing
        do {
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            if overwrite == false {
                fileHandle.seekToEndOfFile()
            } else {
                do {
                    if fileName == "data.csv" {
                        throw FileError.OverwriteData
                    }
                } catch let error as FileError {
                    print(error.rawValue)
                    fatalError()
               
                }
                 fileHandle.truncateFile(atOffset: 0)
            }
           
            fileHandle.write(data.data(using: .utf8)!)
            fileHandle.closeFile()
        } catch {
            print("Error writing to file \(error)")
        }
    }
}
    
func readFromFile(fileName: String) -> String {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

        let fileURL = dir.appendingPathComponent(fileName)
    
        //reading
        do {
            let text = try String(contentsOf: fileURL, encoding: .utf8)
            return text
        }
        catch {/* error handling here */}
    }
    return ""
}

func writeSubjectDataToFile(data: Subject, replace: Bool = false, source: String = "") {
    if replace == true {
        var subjectData = readSubjectDataFromFile()

        for (index, subject) in subjectData.enumerated() {
            if subject.id == source {
                subjectData[index] = data
                break
            }
        }
        var writeData : String = ""
        for subject in subjectData {
            writeData += "\(subject.id),\(subject.condition),\(subject.diameter)\n"
        }
        writeToFile(data: writeData, fileName: "subject-data.csv", overwrite: true)
    } else {
        let writeData = "\(data.id),\(data.condition),\(data.diameter)\n"
        writeToFile(data: writeData, fileName: "subject-data.csv")
    }
}

func readSubjectDataFromFile() -> [Subject] {
    let data = readFromFile(fileName: "subject-data.csv").components(separatedBy: "\n")
    var subjectData = [Subject]()
    for row in data {
        var subject = row.split(separator: ",")
        if subject.count == 3 {
            subjectData.append(Subject(id: String(subject[0]),
                                       condition: String(subject[1]),
                                       diameter: Int(subject[2])!))
        }
    }
    
    return subjectData
}

func writeTrialDataToFile(data: String) {
    writeToFile(data: data, fileName: "data.csv")
}

func writeSessionConstantsToFile(data: String) {
    writeToFile(data: data, fileName: "sessionConstants.csv")
}

func readConstantsFromFile() -> [String: Double] {
    var constants = [String: Double]()
    let temp = readFromFile(fileName: "user-defined-constants.csv").components(separatedBy: "\n")
    
    for row in temp {
        var keyValuePair = row.split(separator: ",")
        if keyValuePair.count == 2 {
            constants[String(keyValuePair[0])] = Double(keyValuePair[1])
        }
    }
    
    return constants
}

func writeConstantToFile(variableName: String, assign: Double) {
    var temp = readConstantsFromFile()
    temp[variableName] = assign
    
    let writeData = (temp.compactMap({ (key, value) -> String in
        return "\(key),\(value)"
    }) as Array).joined(separator: "\n")
    
    writeToFile(data: writeData, fileName: "user-defined-constants.csv", overwrite: true)
}

// Write header for data.csv and session-constants.csv
func writeDataHeader() {
    var dataHeader = "subject id,"
    dataHeader += "subject condition,"
    dataHeader += "session timestamp,"
    dataHeader += "phase,"
    dataHeader += "trial number,"
    dataHeader += "stop stimulus,"
    dataHeader += "screen touched,"
    dataHeader += "response time,"
    dataHeader += "hold phase touches,"
    dataHeader += "direct touch,"
    dataHeader += "diameter"
    writeToFile(data: dataHeader, fileName: "data.csv")
    
    var sessionHeader = "time stamp,"
    sessionHeader += "subject id,"
    sessionHeader += "subject condition,"
    sessionHeader += "phase,"
    sessionHeader += "go stim duration,"
    sessionHeader += "stop stim duration,"
    sessionHeader += "negative reinforcement delay,"
    sessionHeader += "positive reinforcement delay,"
    sessionHeader += "hold phase delay"
    sessionHeader += "session timeout time,"
    sessionHeader += "app version,"
    writeToFile(data: sessionHeader, fileName: "sessionConstants.csv")
}

func makeNewDataFile(timeStamp: String) {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        let dataFileURL = dir.appendingPathComponent("data.csv")
        let sessionDataURL = dir.appendingPathComponent("sessionConstants.csv")
        
        // If the data.csv and sessionConstants.csv file do not exist, create them and
        // write to data.csv header
        if !FileManager.default.fileExists(atPath: dataFileURL.path) &&
            !FileManager.default.fileExists(atPath: sessionDataURL.path) {
            
            FileManager.default.createFile(atPath: dataFileURL.path, contents: nil, attributes: nil)
            FileManager.default.createFile(atPath: sessionDataURL.path, contents: nil, attributes: nil)

            writeDataHeader()
            
        } else { // Rename data.csv using timeStamp and recursively call function
            do {
                let targetDataFileURL = dir.appendingPathComponent("data_\(timeStamp).csv")
                let targetSessionDataURL = dir.appendingPathComponent("sessionConstants_\(timeStamp).csv")
                try FileManager.default.moveItem(at: dataFileURL, to: targetDataFileURL)
                try FileManager.default.moveItem(at: sessionDataURL, to: targetSessionDataURL)

                makeNewDataFile(timeStamp: timeStamp)
            } catch {
                print("Error renaming file \(error)")
            }
        }
    }
}

