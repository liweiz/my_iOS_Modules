//
//  StringTestTests.swift
//  StringTestTests
//
//  Created by Liwei Zhang on 2016-03-17.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import XCTest
@testable import StringTest

class StringTestTests: XCTestCase {
    
    let testHead = "TEST_NAME "
    let testStartNotice = " *** START"
    let testFuncMultiReturn = " * Return."
    let testEndNotice = " *** END"
    
    func printStart(testFuncName: String, testName: String, testIndex: Int) {
        print(testHead + "\(testIndex): " + testFuncName + " *** " + testName + testStartNotice)
    }
    func printFuncReturn(testFuncName: String, testName: String, testIndex: Int, returnIndex: Int) {
        print(testHead + "\(testIndex): " + testFuncName + " *** " + testName + testFuncMultiReturn + "\(returnIndex)")
    }
    func printEnd(testFuncName: String, testName: String, testIndex: Int) {
        print(testHead + "\(testIndex): " + testFuncName + " *** " + testName + testEndNotice)
    }
    
    func testEqualWithLog<T: Equatable>(expression1: T?, expression2: T?, testFuncName: String, testName: String, testIndex: Int, numberOfReturns: Int = 1) {
        printStart(testFuncName, testName: testName, testIndex: testIndex)
        for n in 1...numberOfReturns {
            if numberOfReturns == 1 {
                XCTAssertEqual(expression1, expression2)
            } else {
                printFuncReturn(testFuncName, testName: testName, testIndex: testIndex, returnIndex: n)
                switch n {
                case 1:
                    XCTAssertEqual(expression1.0, expression2.0)
                case 2:
                    XCTAssertEqual(expression1.1, expression2.1)
                case 3:
                    XCTAssertEqual(expression1.2, expression2.2)
                default:
                    print("ATTENTION: one or more return value(s) are not tested.")
                }
            }
        }
        printEnd(testFuncName, testName: testName, testIndex: testIndex)
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSplit() {
        struct Tests {
            let testName: String
            let input: String
            let expectedOutput: (String, String)?
        }
        let stringToTest = "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is."
        let toTests = [
            Tests(testName: "splitted with both head and tail", input: "like", expectedOutput: ("I ", " to name my Test Case so it is obvious to see what method is being called and what the assertion is.")),
            Tests(testName: "splitted with head only", input: "assertion is.", expectedOutput: ("I like to name my Test Case so it is obvious to see what method is being called and what the ", "")),
            Tests(testName: "splitted with tail only", input: "I like ", expectedOutput: ("", "to name my Test Case so it is obvious to see what method is being called and what the assertion is.")),
            Tests(testName: "splitted with empty on both sides", input: "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ("", "")),
            Tests(testName: "splitted with split string not found", input: "dds", expectedOutput: nil)
        ]
        let testFuncName = "split *** "
        var i = 0
        for t in toTests {
            testEqualWithLog(stringToTest.split(t.input), expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i, numberOfReturns: 2)
            //            print(testHead + t.testName + " *** START")
            //            print(testHead + t.testName + " * Return.0")
            //            XCTAssertEqual(stringToTest.split(t.input).headingString, t.expectedOutput.0)
            //            print(testHead + t.testName + " * Return.1")
            //            XCTAssertEqual(stringToTest.split(t.input).tailingString, t.expectedOutput.1)
            //            print(testHead + t.testName + " *** END")
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
