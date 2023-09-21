//
//  Errors.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 8/30/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation

enum FileError: String, Error {
    case OverwriteData = "Attempt to overwrite data.csv"
}

