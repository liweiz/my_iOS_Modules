//
//  stirngExtractorTests.swift
//  stirngExtractorTests
//
//  Created by Liwei Zhang on 2016-03-02.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import XCTest
@testable import stirngExtractor

func overallResultString(testName: String, pass: Bool) -> String {
    return "TEST: " + testName + (pass ? "PASS" : "Failed")
}
func singleOutputResultString(should: String, actual: String) -> String {
    return "Output should be: " + should + ", while actually produced: " + actual + "."
}

class stirngExtractorTests: XCTestCase {
    
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
    
    func testFindRange() {
        struct Tests {
            let testName: String
            let input: String
            let expectedOutput: Range<String.Index>?
        }
        let stringToTest = "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is."
        let toTests = [
            Tests(testName: "findRange *** found with range does not reach end", input: "like", expectedOutput: stringToTest.startIndex.advancedBy(6)..<stringToTest.endIndex),
            Tests(testName: "findRange *** found with range reaches end", input: "assertion is.", expectedOutput: stringToTest.endIndex..<stringToTest.endIndex),
            Tests(testName: "findRange *** not found", input: "assertiof", expectedOutput: nil)
        ]
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            XCTAssertEqual(stringToTest.findRange(t.input), t.expectedOutput)
            print("TEST_NAME: " + t.testName + " *** END")
        }
    }
    
    func testSplit() {
        struct Tests {
            let testName: String
            let input: String
            let expectedOutput: (String?, String?)
        }
        let stringToTest = "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is."
        let toTests = [
            Tests(testName: "split *** splitted with both head and tail", input: "like", expectedOutput: ("I ", " to name my Test Case so it is obvious to see what method is being called and what the assertion is.")),
            Tests(testName: "split *** splitted with head only", input: "assertion is.", expectedOutput: ("I like to name my Test Case so it is obvious to see what method is being called and what the ", "")),
            Tests(testName: "split *** splitted with tail only", input: "I like ", expectedOutput: ("", "to name my Test Case so it is obvious to see what method is being called and what the assertion is.")),
            Tests(testName: "split *** splitted with empty on both sides", input: "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ("", "")),
            Tests(testName: "split *** splitted with split string not found", input: "dds", expectedOutput: (nil, nil))
        ]
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            print("TEST_NAME: " + t.testName + " * Return.0")
            XCTAssertEqual(stringToTest.split(t.input).headingString, t.expectedOutput.0)
            print("TEST_NAME: " + t.testName + " * Return.1")
            XCTAssertEqual(stringToTest.split(t.input).tailingString, t.expectedOutput.1)
            print("TEST_NAME: " + t.testName + " *** END")
        }
    }
    
    func testStirngWithoutHeadTailWhitespaceBetween() {
        struct Tests {
            let testName: String
            let input0: String
            let input1: String
            let expectedOutput: String?
        }
        let stringToTest = "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is."
        let toTests = [
            Tests(testName: "stirngWithoutHeadTailWhitespaceBetween *** both are in the middle", input0: "like", input1: "is", expectedOutput: "to name my Test Case so it"),
            Tests(testName: "stirngWithoutHeadTailWhitespaceBetween *** both are at the ends", input0: "I", input1: ".", expectedOutput: "like to name my Test Case so it is obvious to see what method is being called and what the assertion is"),
            Tests(testName: "stirngWithoutHeadTailWhitespaceBetween *** one not found", input0: "cool", input1: "like", expectedOutput: nil),
        ]
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            XCTAssertEqual(stringToTest.stirngWithoutHeadTailWhitespaceBetween(t.input0, end: t.input1), t.expectedOutput)
            print("TEST_NAME: " + t.testName + " *** END")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
