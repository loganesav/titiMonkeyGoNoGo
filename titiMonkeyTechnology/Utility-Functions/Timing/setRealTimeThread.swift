//
//  File.swift
//  titiMonkeyTechnology
//
//  Created by Scott Reichelt on 5/9/18.
//  Copyright © 2018 titiMonkeyTechnology. All rights reserved.
//
import Darwin
//import Foundation

func setRealTimeThread() {
    var info = mach_timebase_info(numer: 0, denom: 0)
    mach_timebase_info(&info)
    let clock2abs = Double(info.denom) / Double(info.numer) * Double(NSEC_PER_SEC)
    
    let period      = UInt32(0.00 * clock2abs)
    let computation = UInt32(0.03 * clock2abs) // 500 ms of work
    let constraint  = UInt32(0.05 * clock2abs)
    
    let THREAD_TIME_CONSTRAINT_POLICY_COUNT = mach_msg_type_number_t(MemoryLayout<thread_time_constraint_policy>.size / MemoryLayout<integer_t>.size)
    
    var policy = thread_time_constraint_policy()
    var ret: Int32
    let thread: thread_port_t = pthread_mach_thread_np(pthread_self())
    
    policy.period = period
    policy.computation = computation
    policy.constraint = constraint
    policy.preemptible = 0
    
    ret = withUnsafeMutablePointer(to: &policy) {
        $0.withMemoryRebound(to: integer_t.self, capacity: Int(THREAD_TIME_CONSTRAINT_POLICY_COUNT)) {
            thread_policy_set(thread, UInt32(THREAD_TIME_CONSTRAINT_POLICY), $0, THREAD_TIME_CONSTRAINT_POLICY_COUNT)
        }
    }
    
    if ret != KERN_SUCCESS {
        mach_error("thread_policy_set:", ret)
        exit(1)
    }
}
