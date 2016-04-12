//
//  SingleLineTextView.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-04-06.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

// SingleLineTextView is the textView in the form of only one line with all text shown and width that fits.
class SingleLineTextView: UITextView, MoveFollowable, Animatable {
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
        previousOriginX = frame.origin.x
    }
    var previousOriginX: CGFloat?
    var targetLineCharRange: NSRange?

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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var horizontalAnimationDuration: NSTimeInterval = 2
    var horizontalAnimationDelay: NSTimeInterval = 0
    
    var animateHorizontally: (fromPosition: CGFloat, toPosition: CGFloat, completion: ((Bool) -> Void)?) {
        return animateOnSingleAxis!(duration: horizontalAnimationDuration, delay: horizontalAnimationDelay)
    }
    var animateOnSingleAxis: ((duration: NSTimeInterval, delay: NSTimeInterval) -> (fromPosition: CGFloat, toPosition: CGFloat, completion: ((Bool) -> Void)?))?
    // Animatable
    func startHorizontalAnimation(byDelta: CGFloat, delegate: AnyObject?, isFollowed: Bool) {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = layer.position.x
        animation.byValue = byDelta
        animation.duration = horizontalAnimationDuration
        if let f = follower {
            if isFollowed { (f as! SingleLineTextView).startHorizontalAnimation(byDelta, delegate: delegate, isFollowed: isFollowed) }
        }
        layer.addAnimation(animation, forKey: "")
        frame.origin = CGPointMake(frame.origin.x + byDelta, frame.origin.y)
    }
    func analyze(deltasToSyncedPositions: [CGFloat?]) -> [CGFloat]? {
        let d = (deltasToSyncedPositions.filter { $0 != nil }).map { $0! }
        if d.count > 0 {
            let deltaNeeded = d.first!
            var deltaRemained = d.dropFirst().reduce(0, combine: { $0 + $1 })
            var i = 0
            for n in d.dropFirst() {
                deltaRemained = deltaRemained - n
                if deltaRemained <= 0 {
                    break
                }
                i += 1
            }
        }
    }
    func startVerticalAnimation(fromPosition: CGFloat, toPosition: CGFloat) {
        
    }
    func pauseHorizontalAnimation() {
        
    }
    // MoveFollowable
    var follower: UIView?
    func updateFollowerOrigin(deltaToNew: CGFloat) {
        if let f = follower {
            startHorizontalAnimation(deltaToNew)
//            f.frame.origin = CGPointMake(f.frame.origin.x + deltaToNew, f.frame.origin.y)
        }
    }
}

extension SingleLineTextView: Matchable {
    func originToMatch(pointOnAnotherView: CGPoint, anotherView: UIView, pointHere: CGPoint) -> CGPoint {
        return anotherView.originOfAnotherViewToOverlapTwoPoints(pointOnAnotherView, pointInAnotherView: pointHere, anotherView: self)
    }
}


protocol MoveFollowable {
    var follower: UIView? { get set }
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