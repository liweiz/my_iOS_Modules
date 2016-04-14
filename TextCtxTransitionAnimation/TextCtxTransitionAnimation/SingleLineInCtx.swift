//
//  SingleLineInCtx.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-04-14.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

protocol FollowableAsLine: CanImitateLineInCtx {
    var follower: UIView? { get set }
    func lineTailingBlankSpaceRect() -> CGRect?
}

protocol CanImitateLineInCtx {
    var charRangeOfLineImitated: NSRange? { get set }
}

extension FollowableAsLine where Self: UITextView {
    // In SingleLineTextView's coordinates
    func lineTailingBlankSpaceRect() -> CGRect? {
        if let range = charRangeOfLineImitated {
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
    // Because all tailing blank-spaces belong to the upper line, the lower line moves out the blank-spaces to sync with the content shown in upper line, while the upper line stops and waiting for complete of the sync.
    func tailingBlankSpaceCharRange(inText: String, inRange: NSRange) -> NSRange? {
        let text = inText as NSString
        let nextLocation = inRange.location + inRange.length
        if nextLocation > text.length { return nil }
        for i in 1...inRange.length {
            let prevousLocation = nextLocation - i
            if text.substringWithRange(NSMakeRange(prevousLocation, 1)) != " " {
                return NSMakeRange(prevousLocation + 1, i - 1)
            }
        }
        return inRange
    }
}

class SingleLineInCtx: SingleLineTextView, FollowableAsLine {
    //    var targetLineCharRange: NSRange? =>
    var charRangeOfLineImitated: NSRange?
    var follower: UIView?
    
}

