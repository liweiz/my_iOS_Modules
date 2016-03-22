//
//  ViewMatcherTests.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-03-21.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import XCTest
@testable import TextCtxTransitionAnimation

class ViewMatcherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testUIView_originOfAnotherViewToOverlapTwoPoints() {
        struct Tests {
            let testName: String
            let pointInSelf: CGPoint
            let pointInAnotherView: CGPoint
            let anotherView: UIView
            let expectedOutput: CGPoint
        }
        let selfView = UIView(frame: CGRectMake(32, 54, 100, 100))
        let anotherView = UIView(frame: CGRectMake(66, 34, 100, 100))
        selfView.addSubview(anotherView)
        let toTests = [
            Tests(testName: "normal", pointInSelf: CGPointMake(41, 37), pointInAnotherView: CGPointMake(21, 96), anotherView: anotherView, expectedOutput: CGPointMake(66 + (41 - (21 + 66)), 34 + (37 - (96 + 34))))
        ]
        let testFuncName = "UIView.originOfAnotherViewToOverlapTwoPoints"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(selfView.originOfAnotherViewToOverlapTwoPoints(t.pointInSelf, pointInAnotherView: t.pointInAnotherView, anotherView: anotherView), expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
    
    func testCGPoint_DeltaTo() {
        struct Tests {
            let testName: String
            let input: CGPoint
            let expectedOutput: CGPoint
        }
        let selfPoint = CGPointMake(32, 54)
        let toTests = [
            Tests(testName: "normal", input: CGPointMake(25, 97), expectedOutput: CGPointMake(-7, 43))
        ]
        let testFuncName = "CGPoint.deltaTo"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(selfPoint.deltaTo(t.input), expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
    
    
    
}
