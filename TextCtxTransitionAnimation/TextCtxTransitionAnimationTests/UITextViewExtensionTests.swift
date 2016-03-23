//
//  UITextViewExtensionTests.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-03-23.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import XCTest

class UITextViewExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockTextView()
    }
    
    let text = "During the next launch cycle, the view attempts to restore these properties to their saved values. If the selection range cannot be applied to the text in the restored view, no text is selected. For more information about how state preservation and restoration works, see iOS App Programming Guide."
    
    func mockTextView() {
        let textView = UITextView(frame: CGRectMake(100, 40, 150, 80))
        textView.text = text
        let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController?
        rootViewController?.view.addSubview(textView)
    }
    
    func test
}
