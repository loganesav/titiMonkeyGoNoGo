//
//  dateTimeStamp.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 4/25/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Foundation

class dateTimeStamp {
    let timeStamp: Date
    let formatter: DateFormatter
    let timeStampString: String
    
    init(stampedTime: Date) {
        self.timeStamp = stampedTime
        self.formatter = DateFormatter()
        self.formatter.timeZone = TimeZone.current
        self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        self.timeStampString = formatter.string(from: timeStamp)
        
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
