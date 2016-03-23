//
//  NSRangeHelperTests.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-03-22.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import XCTest
@testable import TextCtxTransitionAnimation



class NSRangeHelperTests: XCTestCase {
    
    func testNSRangeSequenceType_rangesIntersect() {
        struct Tests {
            let testName: String
            let ranges: [NSRange]
            let expectedOutput: [NSRange]
        }
        let rangeToIntersect = NSMakeRange(6, 21)
        let toTests = [
            Tests(testName: "not intersected", ranges: [NSMakeRange(1, 3), NSMakeRange(50, 13), NSMakeRange(29, 29)], expectedOutput: [NSRange]()),
            Tests(testName: "one intersected", ranges: [NSMakeRange(1, 3), NSMakeRange(50, 13), NSMakeRange(29, 29), NSMakeRange(7, 10)], expectedOutput: [NSMakeRange(7, 10)]),
            Tests(testName: "two intersected", ranges: [NSMakeRange(1, 3), NSMakeRange(13, 13), NSMakeRange(29, 29), NSMakeRange(7, 10)], expectedOutput: [NSMakeRange(13, 13), NSMakeRange(7, 10)])
        ]
        let testFuncName = "NSRangeSequenceType.rangesIntersect"
        var i = 0
        for t in toTests {
            testNonOptionalElemArrayEqualWithLog(t.ranges.rangesIntersect(rangeToIntersect), expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
    
    func testNSRangeSequenceType_combineContinuousRanges() {
        struct Tests {
            let testName: String
            let ranges: [NSRange]
            let expectedOutput: NSRange?
        }
        let toTests = [
            Tests(testName: "normal", ranges: [NSMakeRange(4, 6), NSMakeRange(10, 13), NSMakeRange(23, 29)], expectedOutput: NSMakeRange(4, 48)),
            Tests(testName: "not a continuous one", ranges: [NSMakeRange(4, 6), NSMakeRange(2, 3), NSMakeRange(13, 9)], expectedOutput: nil),
            Tests(testName: "one element", ranges: [NSMakeRange(4, 6)], expectedOutput: NSMakeRange(4, 6)),
            Tests(testName: "empty", ranges: [NSRange](), expectedOutput: nil)
        ]
        let testFuncName = "NSRangeSequenceType.combineContinuousRanges"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(t.ranges.combineContinuousRanges(), expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
    
    func testNSRangeSequenceType_isComposedOfContinuousRanges() {
        struct Tests {
            let testName: String
            let ranges: [NSRange]
            let expectedOutput: Bool?
        }
        let toTests = [
            Tests(testName: "true", ranges: [NSMakeRange(4, 6), NSMakeRange(10, 3), NSMakeRange(13, 9)], expectedOutput: true),
            Tests(testName: "false", ranges: [NSMakeRange(4, 6), NSMakeRange(2, 3), NSMakeRange(13, 9)], expectedOutput: false),
            Tests(testName: "one element", ranges: [NSMakeRange(4, 6)], expectedOutput: true),
            Tests(testName: "empty", ranges: [NSRange](), expectedOutput: false)
        ]
        let testFuncName = "NSRangeSequenceType.isComposedOfContinuousRanges"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(t.ranges.isComposedOfContinuousRanges, expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
    
}
