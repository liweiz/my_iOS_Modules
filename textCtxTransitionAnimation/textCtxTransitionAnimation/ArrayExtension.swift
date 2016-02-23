//
//  ArrayExtension.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-02-13.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    func pickEvenOrOdd(pickEven: Bool) -> [Element] {
        var r = [Element]()
        var i = 0
        for t in self {
            if i % 2 == 1 {
                r.append(t)
            }
            i += 1
        }
        return r
    }
}

extension Array where Element: Equatable {
    func findElements(beyondElement: Element) -> [Element]? {
        if let i = indexOf(beyondElement) {
            return filter { indexOf($0) > i }
        }
        return nil
    }
    func findElements(beyondIndex: Int) -> [Element]? {
        return count > beyondIndex ? filter { indexOf($0) > beyondIndex } : nil
    }
}

extension Array where Element: Line {
    var visiableCharacterRanges: [NSRange] {
        return map { return $0.visiableCharacterRange }
    }
    var EvenIndexedElements: [Element] {
        return pickEvenOrOdd(true)
    }
    var OddIndexedElements: [Element] {
        return pickEvenOrOdd(false)
    }
    var BaseXs: [CGFloat] {
        return map { return $0.contentOffset.x }
    }
    func scrollAlongX(deltaX: CGFloat, animated: Bool) {
        for l in self {
            l.setContentOffset(CGPointMake(l.contentOffset.x + deltaX, l.contentOffset.y), animated: animated)
        }
    }
    
}

func ==(lhs: NSRange, rhs: NSRange) -> Bool {
    return NSEqualRanges(lhs, rhs)
}

func prepareLines(imitateView: UITextView, visiableCharacterRange: NSRange) -> [Line] {
    var lines = [Line]()
    let linesGlyphRangesAndRects = imitateView.linesGlyphRangesAndRects()
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