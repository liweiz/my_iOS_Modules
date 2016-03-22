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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
