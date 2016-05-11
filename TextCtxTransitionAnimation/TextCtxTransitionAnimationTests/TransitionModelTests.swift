//
//  TransitionModelTests.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-05-07.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import XCTest

class TransitionModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    let textXsByLine: [CGFloat] = [-80, -112, -139, -191]
    let ctxXsByLine: [CGFloat] = [0, -42, -71, -99, -137, -178, -203]
    
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
//            testNonCollectionEqualWithLog(selfView.originOfAnotherViewToOverlapTwoPoints(t.pointInSelf, pointInAnotherView: t.pointInAnotherView, anotherView: anotherView), expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
//            i += 1
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
