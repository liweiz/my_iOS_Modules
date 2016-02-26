//
//  Ctx.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-02-04.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

let fontColor = UIColor.blueColor()
let sysFont = UIFont.systemFontOfSize(16)
//  Each line when it leads the move of following lines has two phases of sliding: 1) matching the line start of the textview it copies 2) hiding the extra part of the line that is not supposed to be shown in the line.

var initialOffsetXs = [CGFloat]()
var mainLeadingXs = [CGFloat]()
var extraLeadingXs = [CGFloat]()

// initLines generates [Line] that imitates the lines contain the visiableCharacterRange in ctx.
func initLines(imitateView: UITextView, visiableCharacterRange: NSRange) -> [Line] {
    var lines = [Line]()
    let linesGlyphRangesAndRects = imitateView.linesGlyphCharacterRangesAndRects()
    var characterRangesForEachLineInViewImitated = [NSRange]()
    if linesGlyphRangesAndRects.glyphRanges.count > 0 {
        for x in linesGlyphRangesAndRects.glyphRanges {
            characterRangesForEachLineInViewImitated.append(imitateView.layoutManager.characterRangeForGlyphRange(x, actualGlyphRange: nil))
        }
        let lineTextViewRect = CGRectMake(0, 0, linesGlyphRangesAndRects.lineRectsInSelfCoordinates[0].size.width * CGFloat(linesGlyphRangesAndRects.lineRectsInSelfCoordinates.count), linesGlyphRangesAndRects.lineRectsInSelfCoordinates[0].size.height)
        var i = 0
        for lineCharacterRange in characterRangesForEachLineInViewImitated.rangesIntersect(visiableCharacterRange) {
            let rangeMain = visiableRange(true, wordsCharacterRange: visiableCharacterRange, lineWordsCharacterRange: lineCharacterRange)
            let rangeExtra = visiableRange(false, wordsCharacterRange: visiableCharacterRange, lineWordsCharacterRange: lineCharacterRange)
            let lineTextViewMain = lineTextView(lineTextViewRect, attriString: imitateView.attributedText, visiableCharRange: rangeMain, color: fontColor)
            let lineTextViewExtra = lineTextView(lineTextViewRect, attriString: imitateView.attributedText, visiableCharRange: rangeExtra, color: fontColor)
            let lineMain = Line(textViewToInsert: lineTextViewMain, rect: linesGlyphRangesAndRects.lineRectsInSelfCoordinates[i])
            let lineExtra = Line(textViewToInsert: lineTextViewExtra, rect: linesGlyphRangesAndRects.lineRectsInSelfCoordinates[i])
            guard let indexInRanges = characterRangesForEachLineInViewImitated.indexOf( { lineCharacterRange == $0 } ) else {
                return [Line]()
            }
            let initialContentOffset = CGPointMake(lineMain.contentSize.width * CGFloat(indexInRanges), 0)
            lineMain.contentOffset = initialContentOffset
            lineExtra.contentOffset = initialContentOffset
            lines.append(lineMain)
            lines.append(lineExtra)
            i += 1
        }
    }
    return lines
}

func ==(lhs: NSRange, rhs: NSRange) -> Bool {
    return NSEqualRanges(lhs, rhs)
}

func lineTextView(frame: CGRect, attriString: NSAttributedString, visiableCharRange: NSRange, color: UIColor) -> UITextView {
    let textViewToAdd = UITextView(frame: frame)
    let s = glyphsVisiabilityWithColor(attriString, charRange: visiableCharRange, color: color)
    s.setAttributes(["NSFontAttributeName": sysFont], range: NSMakeRange(0, s.length))
    textViewToAdd.attributedText = s
    return textViewToAdd
}

// MARK: - Line geometric/character/glyph info
func expectedOffsetXsForLines(textViews: [UITextView], glyphRangesForLines: [NSRange]) -> [CGFloat] {
    var r = [CGFloat]()
    var i = Int(0)
    for v in textViews {
        let boundingRect = v.layoutManager.boundingRectForGlyphRange(glyphRangesForLines[i], inTextContainer: v.textContainer)
        r.append(boundingRect.origin.x)
        i++
    }
    return r
}




