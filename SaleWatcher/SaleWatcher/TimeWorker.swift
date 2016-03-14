//
//  TimeWorker.swift
//  TimeWorker
//
//  Created by Liwei Zhang on 2016-03-13.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

// nextTime looks for the next time amaong times explicitly set(e.g., now it's 07, looking for next time firing some task every 15 mins from 00/15/30/45. delayedBy is to delay the task for N seconds.
func nextTime(amongMinutePresets: [String], delayedBy: Double = 0) -> NSDate? {
    let minsInInt = amongMinutePresets.map { Int($0) }
    if (minsInInt.filter { $0 == nil }).count + (minsInInt.filter { $0 > 60 }).count + (minsInInt.filter { $0 < 0 }).count > 0 {
        return nil
    }
    let m = minsInInt.map { $0! }
    let gregorian = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
    let now = NSDate()
    let nowComponents = gregorian.components([NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: now)
    
    let targetMin = nextMinuteUnit(nowComponents.minute, minPresets: m)
    if let t = targetMin {
        let d = t - nowComponents.minute
        let intervalInMinute = Double(d >= 0 ? d : 60 - nowComponents.minute + d)
        return now.dateByAddingTimeInterval(intervalInMinute * 60)
    }
    return nil
}

func nextMinuteUnit(currentMin: Int, minPresets: [Int]) -> Int? {
    let minDifferences = minPresets.map { $0 - currentMin }
    if let m = (minDifferences.filter { $0 > 0 }).minElement() {
        return currentMin + m
    }
    return minPresets.first
}

