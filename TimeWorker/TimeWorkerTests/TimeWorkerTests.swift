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
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testNextMinuteDigit() {
        struct Test {
            let testName: String
            let currentMin: Int
            let minPresets: [Int]
            let expectedOutput: Int
        }
        let minPresets = [0, 20, 40, 45, 55]
        let toTestExpectingNoError = [
            Test(testName: "nextMinuteDigit *** NoError, greater digit found", currentMin: 43, minPresets: minPresets, expectedOutput: 45),
            Test(testName: "nextMinuteDigit *** NoError, less digit found", currentMin: 56, minPresets: minPresets, expectedOutput: 0),
            Test(testName: "nextMinuteDigit *** NoError, digit from preset", currentMin: 20, minPresets: minPresets, expectedOutput: 40)
        ]
        var i = 0
        for t in toTestExpectingNoError {
            print("TEST_NAME [\(i)]: " + t.testName + " *** START")
            XCTAssertEqual(try! nextMinuteDigit(t.currentMin, minPresets: t.minPresets), t.expectedOutput)
            print("TEST_NAME [\(i)]: " + t.testName + " *** END")
            i += 1
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
