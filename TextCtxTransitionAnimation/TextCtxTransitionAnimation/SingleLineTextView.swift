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
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

protocol CanBeLean {
    func becomeLean()
}

extension CanBeLean where Self: UITextView {
    func becomeLean() {
        textContainer.maximumNumberOfLines = 1
        textContainer.lineFragmentPadding = 0
        textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        sizeToFit()
    }
}

extension SingleLineTextView: CanBeLean{}

protocol Matchable {
    func originToMatch(pointOnAnotherView: CGPoint, anotherView: UIView, pointHere: CGPoint) -> CGPoint
}

extension Matchable where Self: UIView {
    func originToMatch(pointOnAnotherView: CGPoint, anotherView: UIView, pointHere: CGPoint) -> CGPoint {
        return anotherView.originOfAnotherViewToOverlapTwoPoints(pointOnAnotherView, pointInAnotherView: pointHere, anotherView: self)
    }
}

extension SingleLineTextView: Matchable {}

protocol Animatable {
    func startHorizontalAnimation(byDelta: CGFloat, duration: NSTimeInterval, delegate: AnyObject?)
}

extension Animatable where Self: UIView {
    func startHorizontalAnimation(byDelta: CGFloat, duration: NSTimeInterval, delegate: AnyObject? = nil) {
        startAnimationOnOneAxis(byDelta, duration: duration, delegate: delegate, onKeyPath: "position.x", fromValue: layer.position.x)
    }
    func startAnimationOnOneAxis(byDelta: CGFloat, duration: NSTimeInterval, delegate: AnyObject? = nil, onKeyPath: String, fromValue: CGFloat) {
        let animation = CABasicAnimation(keyPath: onKeyPath)
        animation.fromValue = fromValue
        animation.byValue = byDelta
        animation.duration = duration
        //        animation.removedOnCompletion = false
        animation.delegate = delegate
        animation.setValue(tag, forKey: "view tag")
        layer.addAnimation(animation, forKey: "horizontal move")
        frame.origin = CGPointMake(frame.origin.x + byDelta, frame.origin.y)
    }
}

extension SingleLineTextView: Animatable {}

//extension Array where Element: SingleLineTextView {
//    func makeContentsClear(charRangesForEachLine: [NSRange]) {
//        if count == charRangesForEachLine.count {
//            var i = 0
//            for element in self {
//                let line = element as SingleLineTextView
//                line.makeContentClear(charRangesForEachLine[i])
//                i += 1
//            }
//        }
//    }
//}