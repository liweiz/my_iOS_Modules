//
//  SingleLineTextView.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-04-06.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

// SingleLineTextView is the textView in the form of only one line with all text shown and width that fits.
class SingleLineTextView: UITextView, Matchable {
    // It is used to imitate a text line. Text information should be included, too. So NSAttributedString is used as input here.
    init(attriText: NSAttributedString, lineHeight: CGFloat) {
        super.init(frame: CGRectMake(0, 0, 10000, lineHeight), textContainer: nil)
        textContainer.maximumNumberOfLines = 1
        textContainer.lineFragmentPadding = 0
        textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let t = NSMutableAttributedString(attributedString: attriText)
        let fullRange = NSMakeRange(0, attriText.length)
        t.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: fullRange)
        t.addAttribute(NSBackgroundColorAttributeName, value: UIColor.clearColor(), range: fullRange)
        attributedText = t
        backgroundColor = UIColor.clearColor()
        sizeToFit()
    }
    
    func originToMatch(pointOnAnotherView: CGPoint, anotherView: UIView, pointHere: CGPoint) -> CGPoint {
        return anotherView.originOfAnotherViewToOverlapTwoPoints(pointOnAnotherView, pointInAnotherView: pointHere, anotherView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}