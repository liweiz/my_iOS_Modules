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
