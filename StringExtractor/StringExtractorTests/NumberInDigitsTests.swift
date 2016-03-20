//
//  NumberInDigitsTests.swift
//  StringExtractor
//
//  Created by Liwei Zhang on 2016-03-19.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import XCTest
@testable import StringExtractor

class NumberInDigitsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFindNumber() {
        struct Tests {
            let testName: String
            let stringToTest: String
            let expectedOutput: String?
        }
        let toTests = [
            Tests(testName: "normal", stringToTest: " $139.99</B></em><BR></p>", expectedOutput: "139.99"),
            Tests(testName: "numerical digits only", stringToTest: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1342"),
            Tests(testName: "with decimal digits", stringToTest: "I like to name my 1342.1 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1342.1"),
            Tests(testName: "beginning with multiple 0s", stringToTest: "I like to name my 0001342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1342"),
            Tests(testName: "beginning with multiple 0s with decimal mark", stringToTest: "I like to name my 0,001,342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1342"),
            Tests(testName: "beginning with multiple 0s with continuous decimal marks", stringToTest: "I like to name my 0,,001,342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "0"),
            Tests(testName: "beginning with multiple 0s with decimal marks following decimal point", stringToTest: "I like to name my 0,001.,342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1"),
            Tests(testName: "beginning with multiple 0s with decimal marks after decimal point", stringToTest: "I like to name my 0,001.3,4,2 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1.3"),
            Tests(testName: "beginning with multiple 0s with decimal point following decimal mark", stringToTest: "I like to name my 0,001,.342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1"),
            Tests(testName: "no number", stringToTest: "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: nil),
            Tests(testName: "beginning with multiple 0s with continuous decimal points", stringToTest: "I like to name my 0,001..342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1"),
            Tests(testName: "beginning with decimal point", stringToTest: "I like to name my ..342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "342")
        ]
        let testFuncName = "findNumber"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(t.stringToTest.findNumber()?.string, expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
    
    let sampleNumberInDigits = NumberInDigits(numericalDigitIndice: [5, 2, 1], decimalDigitIndice: [3, 9])
    let sampleNumberInDigitsZeroHeading = NumberInDigits(numericalDigitIndice: [0, 2, 1], decimalDigitIndice: [3, 9])
    let sampleNumberInDigitsNumAllZero = NumberInDigits(numericalDigitIndice: [0, 0, 0], decimalDigitIndice: [3, 4])
    
    func testNumberInDigits_IsEmpty() {
        struct Tests {
            let testName: String
            let numberInDigits: NumberInDigits
            let expectedOutput: Bool
        }
        let toTests = [
            Tests(testName: "normal", numberInDigits: sampleNumberInDigits, expectedOutput: false),
            Tests(testName: "empty", numberInDigits: NumberInDigits(numericalDigitIndice: [], decimalDigitIndice: []), expectedOutput: true)
        ]
        let testFuncName = "NumberInDigits.isEmpty"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(t.numberInDigits.isEmpty, expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
    
    func testNumberInDigits_Stirng() {
        struct Tests {
            let testName: String
            let numberInDigits: NumberInDigits
            let expectedOutput: String
        }
        let toTests = [
            Tests(testName: "normal", numberInDigits: sampleNumberInDigits, expectedOutput: "521.39"),
            Tests(testName: "zero heading", numberInDigits: sampleNumberInDigitsZeroHeading, expectedOutput: "21.39"),
            Tests(testName: "num all zero", numberInDigits: sampleNumberInDigitsNumAllZero, expectedOutput: "0.34")
        ]
        let testFuncName = "NumberInDigits.string"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(t.numberInDigits.string, expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
    func testNumberInDigits_Float() {
        struct Tests {
            let testName: String
            let numberInDigits: NumberInDigits
            let expectedOutput: Float
        }
        let toTests = [
            Tests(testName: "normal", numberInDigits: sampleNumberInDigits, expectedOutput: 521.39),
            Tests(testName: "zero heading", numberInDigits: sampleNumberInDigitsZeroHeading, expectedOutput: 21.39),
            // Comparing with float numbers not reliable due to how it's stored.
            Tests(testName: "num all zero", numberInDigits: sampleNumberInDigitsNumAllZero, expectedOutput: 0.34)
        ]
        let testFuncName = "NumberInDigits.float"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(t.numberInDigits.float, expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
}
