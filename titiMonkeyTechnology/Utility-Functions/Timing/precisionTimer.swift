//
//  precisionTimer.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 5/9/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//

import Darwin

struct precisionTimer {
    var start: UInt64 = 0
    var stop: UInt64 = 0
    let numer: UInt64
    let denom: UInt64
    
    init() {
        var info = mach_timebase_info(numer: 0, denom: 0)
        mach_timebase_info(&info)
        numer = UInt64(info.numer)
        denom = UInt64(info.denom)
    }
    
    mutating func Start() {
        start = mach_absolute_time()
    }
    
    mutating func Stop() {
        stop = mach_absolute_time()
    }
    
    var nanoseconds: UInt64 {
        if stop < start {
            return 0
        }
        return ((stop - start) * numer) / denom
    }
    
    var milliseconds: Double {
        return Double(nanoseconds) / 1_000_000
    }
    
    var seconds: Double {
        return Double(nanoseconds) / 1_000_000_000
    }
}
