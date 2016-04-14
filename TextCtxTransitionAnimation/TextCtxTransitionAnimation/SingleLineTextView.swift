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
class SingleLineTextView: UITextView {
    // It is used to imitate a text line. Text information should be included, too. So NSAttributedString is used as input here.
    init(attriText: NSAttributedString, lineHeight: CGFloat) {
        super.init(frame: CGRectMake(0, 0, 10000, lineHeight), textContainer: nil)
        let t = NSMutableAttributedString(attributedString: attriText)
        let fullRange = NSMakeRange(0, attriText.length)
        t.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: fullRange)
        t.addAttribute(NSBackgroundColorAttributeName, value: UIColor.clearColor(), range: fullRange)
        attributedText = t
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

protocol CanBeLean {
    func becomeLean()
}

extension SingleLineTextView: CanBeLean {
    func becomeLean() {
        textContainer.maximumNumberOfLines = 1
        textContainer.lineFragmentPadding = 0
        textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        sizeToFit()
    }
}

protocol Matchable {
    func originToMatch(pointOnAnotherView: CGPoint, anotherView: UIView, pointHere: CGPoint) -> CGPoint
}

extension SingleLineTextView: Matchable {
    func originToMatch(pointOnAnotherView: CGPoint, anotherView: UIView, pointHere: CGPoint) -> CGPoint {
        return anotherView.originOfAnotherViewToOverlapTwoPoints(pointOnAnotherView, pointInAnotherView: pointHere, anotherView: self)
    }
}

protocol Animatable {
    func startHorizontalAnimation(byDelta: CGFloat, duration: NSTimeInterval, delegate: AnyObject?)
}

extension SingleLineTextView: Animatable {
    func startHorizontalAnimation(byDelta: CGFloat, duration: NSTimeInterval, delegate: AnyObject?) {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = layer.position.x
        animation.byValue = byDelta
        animation.duration = duration
//        animation.removedOnCompletion = false
        animation.delegate = delegate
        animation.setValue("\(frame.origin) \(followerIsShadow)", forKey: "ID")
        layer.addAnimation(animation, forKey: "horizontal move")
        frame.origin = CGPointMake(frame.origin.x + byDelta, frame.origin.y)
    }
}

extension Array where Element: SingleLineTextView {
    func makeContentsClear(charRangesForEachLine: [NSRange]) {
        if count == charRangesForEachLine.count {
            var i = 0
            for element in self {
                let line = element as SingleLineTextView
                line.makeContentClear(charRangesForEachLine[i])
                i += 1
            }
        }
    }
}