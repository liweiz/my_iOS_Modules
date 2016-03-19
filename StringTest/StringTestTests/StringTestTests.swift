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
    func testNonCollectionEqualWithLog<T: Equatable>(expression1: T?, expression2: T?, testFuncName: String, testName: String, testIndex: Int) {
        printStart(testFuncName, testName: testName, testIndex: testIndex)
        XCTAssertEqual(expression1, expression2)
        printEnd(testFuncName, testName: testName, testIndex: testIndex)
    }
    func testIsNilWithLog<T>(expression: T?, testFuncName: String, testName: String, testIndex: Int) {
        printStart(testFuncName, testName: testName, testIndex: testIndex)
        XCTAssertNil(expression)
        printEnd(testFuncName, testName: testName, testIndex: testIndex)
    }
    func testTwoElemTupleEqualWithLog<T: Equatable, U: Equatable>(expression1: (T, U), expression2: (T, U), testFuncName: String, testName: String, testIndex: Int) {
        printStart(testFuncName, testName: testName, testIndex: testIndex)
        printFuncReturn(testFuncName, testName: testName, testIndex: testIndex, returnIndex: 0)
        XCTAssertEqual(expression1.0, expression2.0)
        printFuncReturn(testFuncName, testName: testName, testIndex: testIndex, returnIndex: 1)
        XCTAssertEqual(expression1.1, expression2.1)
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
    func testFindRange() {
        struct Tests {
            let testName: String
            let input: String
            let expectedOutput: Range<String.Index>?
        }
        let stringToTest = "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is."
        let toTests = [
            Tests(testName: "found with range does not reach end", input: "like", expectedOutput: stringToTest.startIndex.advancedBy(6)..<stringToTest.endIndex),
            Tests(testName: "found with range reaches end", input: "assertion is.", expectedOutput: stringToTest.endIndex..<stringToTest.endIndex)
        ]
        let testFuncName = "findRange"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(stringToTest.findRange(t.input), expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
        let toTestNotFound = Tests(testName: "not found", input: "assertiof", expectedOutput: nil)
        testIsNilWithLog(stringToTest.findRange(toTestNotFound.input), testFuncName: testFuncName, testName: toTestNotFound.testName, testIndex: i)
    }
    func testStirngWithoutHeadTailWhitespaceBetween() {
        struct Tests {
            let testName: String
            let start: String
            let end: String
            let expectedOutput: String?
        }
        let stringToTest = "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is."
        let toTests = [
            Tests(testName: "stirngWithoutHeadTailWhitespaceBetween *** both are in the middle", start: "like", end: "is", expectedOutput: "to name my Test Case so it"),
            Tests(testName: "stirngWithoutHeadTailWhitespaceBetween *** both are at the ends", start: "I", end: ".", expectedOutput: "like to name my Test Case so it is obvious to see what method is being called and what the assertion is")
            ]
        let testFuncName = "stirngWithoutHeadTailWhitespaceBetween"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(stringToTest.stirngWithoutHeadTailWhitespaceBetween(t.start, end: t.end), expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
        let toTestNotFound = Tests(testName: "stirngWithoutHeadTailWhitespaceBetween *** one not found", start: "cool", end: "like", expectedOutput: nil)
        testIsNilWithLog(stringToTest.stirngWithoutHeadTailWhitespaceBetween(toTestNotFound.start, end: toTestNotFound.end), testFuncName: testFuncName, testName: toTestNotFound.testName, testIndex: i)
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
            Tests(testName: "splitted with empty on both sides", input: "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ("", ""))
        ]
        let testFuncName = "split"
        var i = 0
        for t in toTests {
            testTwoElemTupleEqualWithLog(stringToTest.split(t.input)!, expression2: t.expectedOutput!, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
        let toTestNotFound = Tests(testName: "splitted with split string not found", input: "dds", expectedOutput: nil)
        testIsNilWithLog(stringToTest.split(toTestNotFound.input), testFuncName: testFuncName, testName: toTestNotFound.testName, testIndex: i)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
