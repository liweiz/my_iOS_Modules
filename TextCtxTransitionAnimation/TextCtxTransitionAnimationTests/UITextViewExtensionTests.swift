//
//  UITextViewExtensionTests.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-03-23.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import XCTest
@testable import TextCtxTransitionAnimation

class UITextViewExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewToMock.text = text
    }
    
    func testUITextViewExtension_glyphRangeForText() {
        struct Tests {
            let testName: String
            let textView: UITextView
            let input: String
            let expectedOutput: NSRange?
        }
        let toTests = [
            Tests(testName: "normal", textView: viewToMock, input: "preservation and restoration works, ", expectedOutput: viewToMock.layoutManager.glyphRangeForCharacterRange(line7charRange, actualCharacterRange: nil))
        ]
        let testFuncName = "UITextViewExtension.glyphRangeForText"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(t.textView.glyphRangeForText(t.input)!, expression2: t.expectedOutput!, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
        let nilTest = Tests(testName: "not found", textView: viewToMock, input: "abscdas", expectedOutput: nil)
        testIsNilWithLog(nilTest.textView.glyphRangeForText(nilTest.input), testFuncName: testFuncName, testName: nilTest.testName, testIndex: 0)
    }
    
    func testUITextViewExtension_charRangesForEachLine() {
        struct Tests {
            let testName: String
            let textView: UITextView
            let expectedOutput: [NSRange]?
        }
        let toTests = [
            Tests(testName: "normal", textView: viewToMock, expectedOutput: [line0charRange, line1charRange, line2charRange, line3charRange, line4charRange, line5charRange, line6charRange, line7charRange, line8charRange])
        ]
        let testFuncName = "UITextViewExtension.charRangesForEachLine"
        var i = 0
        for t in toTests {
            testNonOptionalElemArrayEqualWithLog(t.textView.charRangesForEachLine!, expression2: t.expectedOutput!, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
        let nilTest = Tests(testName: "empty", textView: emptyTextView, expectedOutput: nil)
        testIsNilWithLog(nilTest.textView.charRangesForEachLine, testFuncName: testFuncName, testName: nilTest.testName, testIndex: 0)
    }
    
    func testUITextViewExtension_lineFragmentRectForEachLine() {
        struct Tests {
            let testName: String
            let textView: UITextView
            let expectedOutput: [String]? // CGRect equatable has float issue.
        }
        let toTests = [
            Tests(testName: "normal", textView: viewToMock, expectedOutput: [line0Rect, line1Rect, line2Rect, line3Rect, line4Rect, line5Rect, line6Rect, line7Rect, line8Rect].map { $0.string })
        ]
        let testFuncName = "UITextViewExtension.lineFragmentRectForEachLine"
        var i = 0
        for t in toTests {
            testNonOptionalElemArrayEqualWithLog(t.textView.lineFragmentRectForEachLine!.map { $0.string }, expression2: t.expectedOutput!, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
        let nilTest = Tests(testName: "empty", textView: emptyTextView, expectedOutput: nil)
        testIsNilWithLog(nilTest.textView.lineFragmentRectForEachLine, testFuncName: testFuncName, testName: nilTest.testName, testIndex: 0)
    }
    
    func testUITextViewExtension_lineFragmentRect() {
        struct Tests {
            let testName: String
            let textView: UITextView
            let characterIndex: Int
            let expectedOutput: CGRect?
        }
        let toTests = [
            Tests(testName: "glyph index from 2nd line", textView: viewToMock, characterIndex: 45, expectedOutput: line1Rect),
            Tests(testName: "invalid index", textView: emptyTextView, characterIndex: 1, expectedOutput: nil)
        ]
        let testFuncName = "UITextViewExtension.lineFragmentRect"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(t.textView.lineFragmentRect(t.characterIndex), expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
    
    func testUITextViewExtension_hasNonEmptyTextContent() {
        struct Tests {
            let testName: String
            let textView: UITextView
            let expectedOutput: Bool
        }
        
        let normalTextView = UITextView()
        normalTextView.text = "1"
        let toTests = [
            Tests(testName: "no text is given", textView: emptyTextView, expectedOutput: false),
            Tests(testName: "normal", textView: normalTextView, expectedOutput: true)
        ]
        let testFuncName = "UITextViewExtension.hasNonEmptyTextContent"
        var i = 0
        for t in toTests {
            testNonCollectionEqualWithLog(t.textView.hasNonEmptyTextContent, expression2: t.expectedOutput, testFuncName: testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
}

let text = "During the next launch cycle, the view attempts to restore these properties to their saved values. If the selection range cannot be applied to the text in the restored view, no text is selected. For more information about how state preservation and restoration works, see iOS App Programming Guide."
let line0Text = "DDuring the next launch cycle, the "
let line1Text = "view attempts to restore these "
let line2Text = "properties to their saved values. If "
let line3Text = "the selection range cannot be "
let line4Text = "applied to the text in the restored "
let line5Text = "view, no text is selected. For more "
let line6Text = "information about how state "
let line7Text = "preservation and restoration works, "
let line8Text = "see iOS App Programming Guide."
let viewToMock = UITextView(frame: CGRectMake(100, 40, 200, 150))

let line0Rect = CGRectMake(0.0, 0.0, 200.0, 13.8)
let line1Rect = CGRectMake(0.0, 13.8, 200.0, 13.8)
let line2Rect = CGRectMake(0.0, 27.6, 200.0, 13.8)
let line3Rect = CGRectMake(0.0, 41.4, 200.0, 13.8)
let line4Rect = CGRectMake(0.0, 55.2, 200.0, 13.8)
let line5Rect = CGRectMake(0.0, 69.0, 200.0, 13.8)
let line6Rect = CGRectMake(0.0, 82.8, 200.0, 13.8)
let line7Rect = CGRectMake(0.0, 96.6, 200.0, 13.8)
let line8Rect = CGRectMake(0.0, 110.4, 200.0, 13.8)

let line0charRange = NSMakeRange(0, 34)
let line1charRange = NSMakeRange(34, 65 - 34)
let line2charRange = NSMakeRange(65, 102 - 65)
let line3charRange = NSMakeRange(102, 132 - 102)
let line4charRange = NSMakeRange(132, 168 - 132)
let line5charRange = NSMakeRange(168, 204 - 168)
let line6charRange = NSMakeRange(204, 232 - 204)
let line7charRange = NSMakeRange(232, 268 - 232)
let line8charRange = NSMakeRange(268, 298 - 268)

let emptyTextView = UITextView()

// Copy below to a viewController and run to see the actual layout.
//    let text = "During the next launch cycle, the view attempts to restore these properties to their saved values. If the selection range cannot be applied to the text in the restored view, no text is selected. For more information about how state preservation and restoration works, see iOS App Programming Guide."
//    func mockTextView() {
//        let textView = UITextView(frame: CGRectMake(100, 40, 200, 150))
//        textView.text = text
//        let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
//        rootViewController?.view.addSubview(textView)
//        for index in textView.layoutManager.glyphRangeForTextContainer(textView.textContainer).location..<(textView.layoutManager.glyphRangeForTextContainer(textView.textContainer).location + textView.layoutManager.glyphRangeForTextContainer(textView.textContainer).length) {
//            let characterIndex = textView.layoutManager.characterIndexForGlyphAtIndex(index)
//            let characterString = (textView.text as NSString).substringWithRange(NSMakeRange(characterIndex, 1))
//            let locationY = textView.layoutManager.lineFragmentRectForGlyphAtIndex(index, effectiveRange: nil).origin.y
//            print("glyph: \(index), \(characterString), \(locationY)")
//        }
//    }

