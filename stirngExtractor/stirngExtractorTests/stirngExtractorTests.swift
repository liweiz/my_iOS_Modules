//
//  stirngExtractorTests.swift
//  stirngExtractorTests
//
//  Created by Liwei Zhang on 2016-03-02.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import XCTest
@testable import stirngExtractor

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
    
    func testStringBetween() {
        struct Tests {
            let testName: String
            let input0: String
            let input1: String
            let expectedOutput: String?
        }
        let stringToTest = "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is."
        let toTests = [
            Tests(testName: "stringBetween *** both are in the middle", input0: "like", input1: "is", expectedOutput: " to name my Test Case so it "),
            Tests(testName: "stringBetween *** both are at the ends", input0: "I", input1: ".", expectedOutput: " like to name my Test Case so it is obvious to see what method is being called and what the assertion is"),
            Tests(testName: "stringBetween *** one not found", input0: "cool", input1: "like", expectedOutput: nil),
            ]
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            XCTAssertEqual(stringToTest.stringBetween(t.input0, end: t.input1), t.expectedOutput)
            print("TEST_NAME: " + t.testName + " *** END")
        }
    }
    
    func testFindNumber() {
        struct Tests {
            let testName: String
            let stringToTest: String
            let expectedOutput: Float?
        }
        let toTests = [
            Tests(testName: "findNumber *** numerical digits only", stringToTest: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: Float(1342)),
            Tests(testName: "findNumber *** with decimal digits", stringToTest: "I like to name my 1342.1 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: Float(1342.1)),
            Tests(testName: "findNumber *** beginning with multiple 0s", stringToTest: "I like to name my 0001342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: Float(1342)),
            Tests(testName: "findNumber *** beginning with multiple 0s with decimal mark", stringToTest: "I like to name my 0,001,342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: Float(1342)),
            Tests(testName: "findNumber *** beginning with multiple 0s with continuous decimal marks", stringToTest: "I like to name my 0,,001,342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: Float(0)),
            Tests(testName: "findNumber *** beginning with multiple 0s with decimal marks following decimal point", stringToTest: "I like to name my 0,001.,342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: Float(1)),
            Tests(testName: "findNumber *** beginning with multiple 0s with decimal marks after decimal point", stringToTest: "I like to name my 0,001.3,4,2 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: Float(1.3)),
            Tests(testName: "findNumber *** beginning with multiple 0s with decimal point following decimal mark", stringToTest: "I like to name my 0,001,.342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: Float(1)),
            Tests(testName: "findNumber *** no number", stringToTest: "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: nil),
            Tests(testName: "findNumber *** beginning with multiple 0s with continuous decimal points", stringToTest: "I like to name my 0,001..342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: Float(1)),
            Tests(testName: "findNumber *** beginning with decimal point", stringToTest: "I like to name my ..342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: Float(342))
        ]
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            XCTAssertEqual(t.stringToTest.findNumber(), t.expectedOutput)
            print("TEST_NAME: " + t.testName + " *** END")
        }
    }
    
    func testStrings() {
        struct Tests {
            let testName: String
            let stringArrayToTest: [String]
            let input: String
            let expectedOutput: [String?]
        }
        let toTests = [
            Tests(testName: "strings *** all found with non-empty results", stringArrayToTest: [" ", "to", "my", "so"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ["like ", " name ", " 1342 Test Case ", " it is obvious to see what method is being called and what the assertion is."]),
            Tests(testName: "strings *** all found with some empty results", stringArrayToTest: [" ", "to", "my", "so", "."], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ["like ", " name ", " 1342 Test Case ", " it is obvious to see what method is being called and what the assertion is", ""]),
            Tests(testName: "strings *** all found with some nil results", stringArrayToTest: [" ", "goo", "my", "so"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ["like to name ", nil, " 1342 Test Case ", " it is obvious to see what method is being called and what the assertion is."]),
            Tests(testName: "strings *** all found except the first one", stringArrayToTest: ["  ", "to", "my", "so", "."], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: [nil, " name ", " 1342 Test Case ", " it is obvious to see what method is being called and what the assertion is", ""]),
            Tests(testName: "strings *** all not found except the last one", stringArrayToTest: ["  ", "goo", "myd", "so"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: [nil, nil, nil, " it is obvious to see what method is being called and what the assertion is."]),
            Tests(testName: "strings *** all not found except the first and last one", stringArrayToTest: [" ", "goo", "myd", "so"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ["like to name my 1342 Test Case ", nil, nil, " it is obvious to see what method is being called and what the assertion is."]),
            Tests(testName: "strings *** all not found", stringArrayToTest: ["  ", "goo", "myd", "soe"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: [nil, nil, nil, nil]),
        ]
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            for i in 0..<t.expectedOutput.count {
                XCTAssertEqual(t.stringArrayToTest.strings(t.input)[i], t.expectedOutput[i])
            }
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
