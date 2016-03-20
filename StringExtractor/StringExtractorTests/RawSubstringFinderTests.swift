//
//  RawSubstringFinderTests.swift
//  StringExtractor
//
//  Created by Liwei Zhang on 2016-03-19.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import XCTest
@testable import StringExtractor

class RawSubstringFinderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    func testStringBetween() {
        struct Tests {
            let testName: String
            let start: String
            let end: String
            let expectedOutput: String?
        }
        let stringToTest = "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is."
        let toTests = [
            Tests(testName: "both are in the middle", start: "like", end: "is", expectedOutput: " to name my Test Case so it "),
            Tests(testName: "both are at the ends", start: "I", end: ".", expectedOutput: " like to name my Test Case so it is obvious to see what method is being called and what the assertion is"),
            Tests(testName: "overlaping start and end", start: "I like to", end: "ke to n", expectedOutput: "")
        ]
        let testFuncName = "stringBetween"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(stringToTest.stringBetween(t.start, end: t.end), expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
        let toTestNotFound = Tests(testName: "stringBetween *** one not found", start: "cool", end: "like", expectedOutput: nil)
        testIsNilWithLog(stringToTest.stringBetween(toTestNotFound.start, end: toTestNotFound.end), testFuncName: testFuncName, testName: toTestNotFound.testName, testIndex: i)
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
    
    func testSubstrings() {
        struct Tests {
            let testName: String
            let stringArrayToTest: [String]
            let input: String
            let expectedOutput: [String?]
        }
        let toTests = [
            Tests(testName: "all found with non-empty results", stringArrayToTest: [" ", "to", "my", "so"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ["like ", " name ", " 1342 Test Case ", " it is obvious to see what method is being called and what the assertion is."]),
            Tests(testName: "all found with some empty results", stringArrayToTest: [" ", "to", "my", "so", "."], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ["like ", " name ", " 1342 Test Case ", " it is obvious to see what method is being called and what the assertion is", ""]),
            Tests(testName: "all found with some nil results", stringArrayToTest: [" ", "goo", "my", "so"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ["like to name ", nil, " 1342 Test Case ", " it is obvious to see what method is being called and what the assertion is."]),
            Tests(testName: "all found except the first one", stringArrayToTest: ["  ", "to", "my", "so", "."], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: [nil, " name ", " 1342 Test Case ", " it is obvious to see what method is being called and what the assertion is", ""]),
            Tests(testName: "all not found except the last one", stringArrayToTest: ["  ", "goo", "myd", "so"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: [nil, nil, nil, " it is obvious to see what method is being called and what the assertion is."]),
            Tests(testName: "all not found except the first and last one", stringArrayToTest: [" ", "goo", "myd", "so"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ["like to name my 1342 Test Case ", nil, nil, " it is obvious to see what method is being called and what the assertion is."]),
            Tests(testName: "all not found", stringArrayToTest: ["  ", "goo", "myd", "soe"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: [nil, nil, nil, nil]),
            ]
        let testFuncName = "substrings"
        var i = 0
        for t in toTests {
            testArrayEqualWithLog(t.stringArrayToTest.substrings(t.input), expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
}
