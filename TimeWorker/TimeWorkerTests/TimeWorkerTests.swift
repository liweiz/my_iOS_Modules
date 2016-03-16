//
//  TimeWorkerTests.swift
//  TimeWorkerTests
//
//  Created by Liwei Zhang on 2016-03-13.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import XCTest
@testable import TimeWorker

class TimeWorkerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWhenIsNextTime() {
        let fromTimeComponent = NSDateComponents()
        fromTimeComponent.year = 2016
        fromTimeComponent.month = 1
        fromTimeComponent.day = 21
        let hour = 18
        fromTimeComponent.hour = hour
        fromTimeComponent.minute = 14
        fromTimeComponent.timeZone = NSTimeZone(abbreviation: "UTC")
        fromTimeComponent.calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let minutes = [0, 14, 21, 57]
        let fromTimes = minutes.map {
            (minute: Int) -> NSDate in
            fromTimeComponent.minute = minute
            return fromTimeComponent.date!
        }
        struct Test {
            let testName: String
            let fromTime: NSDate
            let amongMinutePresets: [String]
            let delayedBy: Double
            let expectedOutput: NSDate?
            let expectedError: ErrorType?
        }
        let amongMinutePresetsString = ["0", "20", "40", "45", "55"]
        let amongMinutePresets = [0, 20, 40, 45, 55]
        let nextTimes = amongMinutePresets.map {
            (minute: Int) -> NSDate in
            fromTimeComponent.minute = minute
            if fromTimeComponent.minute == 0 {
                fromTimeComponent.hour += 1
            } else {
                fromTimeComponent.hour = hour
            }
            return fromTimeComponent.date!
        }
        let toTestExpectingNoError = [
            Test(testName: "NoError, greater minute digit found no delay", fromTime: fromTimes[1], amongMinutePresets: amongMinutePresetsString, delayedBy: 0, expectedOutput: nextTimes[1], expectedError: nil),
            Test(testName: "NoError, less minute digit found no delay", fromTime: fromTimes[3], amongMinutePresets: amongMinutePresetsString, delayedBy: 0, expectedOutput: nextTimes[0], expectedError: nil),
            Test(testName: "NoError, digit from preset no delay", fromTime: fromTimes[0], amongMinutePresets: amongMinutePresetsString, delayedBy: 0, expectedOutput: nextTimes[1], expectedError: nil)
        ]
        var i = 0
        let testTargetName = "whenIsNextTime *** "
        for t in toTestExpectingNoError {
            print("TEST_NAME [\(i)]: " + testTargetName + t.testName + " *** START")
            XCTAssertEqual(try! whenIsNextTime(t.fromTime, amongMinutePresets: t.amongMinutePresets, delayedBy: 0), t.expectedOutput)
            print("TEST_NAME [\(i)]: " + testTargetName + t.testName + " *** END")
            i += 1
        }
        let toTestExpectingError = [
            Test(testName: "Error, empty Presets input", fromTime: NSDate(), amongMinutePresets: [], delayedBy: 0, expectedOutput: nil, expectedError: TimeError.InvalidInput("Invalid input: preset minute digit array should not be empty")),
            Test(testName: "Error, out of range input", fromTime: NSDate(), amongMinutePresets: ["60"], delayedBy: 0, expectedOutput: nil, expectedError: TimeError.InvalidInput("Invalid input: minute digit: 60")),
            Test(testName: "Error, amongMinutePresets not convertible to [Int] from [String]", fromTime: NSDate(), amongMinutePresets: ["0,"], delayedBy: 0, expectedOutput: nil, expectedError: TimeError.InvalidInput("Invalid input: preset minute digit array failed to be converted to [Int]"))
        ]
        var j = 0
        for t in toTestExpectingError {
            print("TEST_NAME [\(j)]: " + testTargetName + t.testName + " *** START")
            XCTAssertThrowsError(try whenIsNextTime(t.fromTime, amongMinutePresets: t.amongMinutePresets, delayedBy: 0))
            print("TEST_NAME [\(j)]: " + testTargetName + t.testName + " *** END")
            j += 1
        }
    }
    
    func testNextMinuteDigit() {
        struct Test {
            let testName: String
            let currentMin: Int
            let minPresets: [Int]
            let expectedOutput: Int?
            let expectedError: ErrorType?
        }
        let minPresets = [0, 20, 40, 45, 55]
        let toTestExpectingNoError = [
            Test(testName: "NoError, greater digit found", currentMin: 43, minPresets: minPresets, expectedOutput: 45, expectedError: nil),
            Test(testName: "NoError, less digit found", currentMin: 56, minPresets: minPresets, expectedOutput: 0, expectedError: nil),
            Test(testName: "NoError, digit from preset", currentMin: 20, minPresets: minPresets, expectedOutput: 40, expectedError: nil)
        ]
        var i = 0
        let testTargetName = "nextMinuteDigit *** "
        for t in toTestExpectingNoError {
            print("TEST_NAME [\(i)]: " + testTargetName + t.testName + " *** START")
            XCTAssertEqual(try! nextMinuteDigit(t.currentMin, minPresets: t.minPresets), t.expectedOutput)
            print("TEST_NAME [\(i)]: " + testTargetName + t.testName + " *** END")
            i += 1
        }
        let toTestExpectingError = [
            Test(testName: "Error, empty minPresets input", currentMin: 43, minPresets: [], expectedOutput: nil, expectedError: TimeError.InvalidInput("Invalid input: preset minute digit array should not be empty")),
            Test(testName: "Error, out of range input", currentMin: 60, minPresets: minPresets, expectedOutput: nil, expectedError: TimeError.InvalidInput("Invalid input: minute digit: 60")),
            Test(testName: "Error, out of range input", currentMin: 0, minPresets: [99, 7], expectedOutput: nil, expectedError: TimeError.InvalidInput("Invalid input: minute digit: 99"))
        ]
        var j = 0
        for t in toTestExpectingError {
            print("TEST_NAME [\(j)]: " + testTargetName + t.testName + " *** START")
            XCTAssertThrowsError(try nextMinuteDigit(t.currentMin, minPresets: t.minPresets))
            print("TEST_NAME [\(j)]: " + testTargetName + t.testName + " *** END")
            j += 1
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
