//
//  UtilFuncs.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-02-01.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit



func glyphsVisiabilityWithColor(aString: NSAttributedString, charRange: NSRange, color: UIColor) -> NSMutableAttributedString {
    let s = NSMutableAttributedString(attributedString: aString)
    s.addAttribute(NSForegroundColorAttributeName, value: UIColor.clearColor(), range: NSMakeRange(0, (s.string as NSString).length))
    s.addAttribute(NSForegroundColorAttributeName, value: color, range: charRange)
    return s
}

func visiableRange(isForMain: Bool, wordsCharacterRange: NSRange, lineWordsCharacterRange: NSRange) -> NSRange {
    return isForMain ? NSMakeRange(wordsCharacterRange.location, lineWordsCharacterRange.location + lineWordsCharacterRange.length - 1) : NSMakeRange(lineWordsCharacterRange.location + lineWordsCharacterRange.length, wordsCharacterRange.location + wordsCharacterRange.length - 1)
}

func linesRects(firstOrigin: CGPoint, linesRectsInTextView: [CGRect]) -> [CGRect] {
    var r = [CGRect]()
    let d = linesRectsInTextView[0].origin.deltaTo(firstOrigin)
    if d.x * d.y != 0 {
        for x in linesRectsInTextView {
            r.append(CGRect(x: x.origin.x + d.x, y: x.origin.y + d.y, width: x.size.width, height: x.size.height))
        }
    }
    return r
}
// We use [CGPoint] as the data container to record each line's move on each step. There is a [[CGPoint]] used as a container to record all the moves each line takes for all the steps.
func initialOffsetX(contentViewWidth: CGFloat, lineIndex: Int) -> [CGFloat] {
    var r = [CGFloat]()
    for i in 0 ... lineIndex {
        r.append(contentViewWidth * CGFloat(i))
    }
    return r
}
// offsetToFollowAboveLine can only be used for lines made of the same UIScrollView structure.
func offsetToFollowAboveLine(aboveLineOffset: CGPoint, aboveLineSize: CGSize) -> CGPoint {
    return CGPointMake(aboveLineOffset.x + aboveLineSize.width, aboveLineOffset.y + aboveLineSize.height)
}

