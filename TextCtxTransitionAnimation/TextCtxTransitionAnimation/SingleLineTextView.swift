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
class SingleLineTextView: UITextView, MoveFollowable {
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
    var targetLineCharRange: NSRange?
    var follower: SingleLineTextView?
    var lineTailingBlankSpaceRectInSelf: CGRect? {
        if let range = targetLineCharRange {
            if let rect = lineTailingBlankSpaceRectInTextContainerCoordinates(range) {
                let origin = convertFromTextContainerCoordinatesToSelf(rect.origin)
                return CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height)
            }
        }
        return nil
    }
    func lineTailingBlankSpaceRectInTextContainerCoordinates(inRange: NSRange) -> CGRect? {
        if let range = tailingBlankSpaceCharRange(text, inRange: inRange) {
            if range.length == 0 { return nil }
            return rectForCharRangeInTextContainerCoordinates(range)
        }
        return nil
    }
    func updateFollowerOrigin(deltaToNew: CGFloat) {
        if let f = follower {
            f.frame.origin = CGPointMake(f.frame.origin.x + deltaToNew, f.frame.origin.y)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        didSet {
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "SingleLineTextView rect updated", object: self, userInfo: nil))
        }
    }
    
    
}

extension SingleLineTextView: Matchable {
    func originToMatch(pointOnAnotherView: CGPoint, anotherView: UIView, pointHere: CGPoint) -> CGPoint {
        return anotherView.originOfAnotherViewToOverlapTwoPoints(pointOnAnotherView, pointInAnotherView: pointHere, anotherView: self)
    }
}

extension SingleLineTextView: Animatable {
    func startHorizontalAnimation(fromPosition: CGFloat, toPosition: CGFloat) {
        
    }
    func startVerticalAnimation(fromPosition: CGFloat, toPosition: CGFloat) {
        
    }
    func pauseHorizontalAnimation() {
        
    }
}

protocol MoveFollowable {
    var follower: Self { get set }
    func updateFollowerOrigin(deltaToNew: CGFloat)
}

protocol HorizontalAnimationPausable {
    func pauseHorizontalAnimation()
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
    func updateOriginXs(deltaToNew: CGFloat) {
        forEach {
            let line = $0 as SingleLineTextView
            line.frame.origin = CGPointMake(line.frame.origin.x + deltaToNew, line.frame.origin.y)
        }
    }
}