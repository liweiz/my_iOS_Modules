//
//  TimeWorker.swift
//  TimeWorker
//
//  Created by Liwei Zhang on 2016-03-13.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

enum TimeError: ErrorType {
    case InvalidInput(String)
}

// whenIsNextTime looks for the next time among times explicitly set(e.g., now it's 07, looking for next time firing some task every 15 mins from 00/15/30/45. delayedBy is to delay the task for N seconds.
func whenIsNextTime(amongMinutePresets: [String], delayedBy: Double = 0) throws -> NSDate {
    guard amongMinutePresets.count > 0 else {
        throw TimeError.InvalidInput("Invalid input: preset minute digit array should not be empty")
    }
    var minsInInt = [Int]()
    for x in amongMinutePresets {
        guard let y = Int(x) else {
            throw TimeError.InvalidInput("Invalid input: preset minute digit array failed to be converted to [Int]")
        }
        minsInInt.append(y)
    }
    for x in minsInInt {
        guard (x >= 0 || x < 60) else { throw TimeError.InvalidInput("Invalid input for minute digit: \(x)") }
    }
    let gregorian = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
    let now = NSDate()
    let nowComponents = gregorian.components([NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: now)
    let nextMinDigit = try nextMinuteDigit(nowComponents.minute, minPresets: minsInInt)
    let delta = nextMinDigit - nowComponents.minute
    let intervalInMinute = Double(delta >= 0 ? delta : 60 - nowComponents.minute + delta)
    return now.dateByAddingTimeInterval(intervalInMinute * 60)
}

// nextMinuteDigit returns the next minute digit among the preset minute digits
func nextMinuteDigit(currentMin: Int, minPresets: [Int]) throws -> Int {
    guard minPresets.count > 0 else {
        throw TimeError.InvalidInput("Invalid input: empty preset minute digit array")
    }
    for x in minPresets + [currentMin] {
        guard x >= 0 || x < 60 else {
            throw TimeError.InvalidInput("Invalid input: minute digit: \(x)")
        }
    }
    let differencesInMin = minPresets.map { $0 - currentMin }
    if let shortestDistance = (differencesInMin.filter { $0 > 0 }).minElement() { return currentMin + shortestDistance }
    return minPresets.first!
}

