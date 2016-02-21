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

extension SequenceType where Self.Generator.Element == NSRange {
    func rangeIntersected(range: NSRange) -> (NSRange) -> NSRange {
        return {(r: NSRange) -> NSRange in
            return NSIntersectionRange(r, range)
        }
    }
    func rangesIntersect(range: NSRange) -> [NSRange] {
        let x = rangeIntersected(range)
        return filter { x($0).length > 0 }
    }
    func combineContinuousRanges(startLocation: Int) -> NSRange {
        if underestimateCount() > 0 {
            var l = 0
            for range in self {
                l = l + range.length
            }
            return NSMakeRange(startLocation, l)
        }
        return NSMakeRange(0, 0)
    }
}

extension Array where Element: Line {
//    let visiableCharacterRanges: [NSRange]
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
    mutating func prepareLines(imitateView: UITextView, visiableCharacterRange: NSRange) {
        let linesGlyphRangesAndRects = imitateView.linesGlyphRangesAndRects()
        var characterRangesForEachLineInViewImitated = [NSRange]()
        if linesGlyphRangesAndRects.glyphRanges.count > 0 {
            for x in linesGlyphRangesAndRects.glyphRanges {
                characterRangesForEachLineInViewImitated.append(imitateView.layoutManager.characterRangeForGlyphRange(x, actualGlyphRange: nil))
            }
            let lineTextViewRect = CGRectMake(0, 0, linesGlyphRangesAndRects.lineRectsInSelfCoordinates[0].size.width * CGFloat(linesGlyphRangesAndRects.lineRectsInSelfCoordinates.count), linesGlyphRangesAndRects.lineRectsInSelfCoordinates[0].size.height)
            var i = 0
            for x in characterRangesForEachLineInViewImitated.rangesIntersect(visiableCharacterRange) {
                let rangeMain = visiableRange(true, wordsCharacterRange: visiableCharacterRange, lineWordsCharacterRange: x)
                let rangeExtra = visiableRange(false, wordsCharacterRange: visiableCharacterRange, lineWordsCharacterRange: x)
                let lineTextViewMain = lineTextView(lineTextViewRect, attriString: imitateView.attributedText, visiableCharRange: rangeMain, color: fontColor)
                let lineTextViewExtra = lineTextView(lineTextViewRect, attriString: imitateView.attributedText, visiableCharRange: rangeExtra, color: fontColor)
                let lineMain = Line(textViewToInsert: lineTextViewMain, rect: linesGlyphRangesAndRects.lineRectsInSelfCoordinates[i])
                let lineExtra = Line(textViewToInsert: lineTextViewExtra, rect: linesGlyphRangesAndRects.lineRectsInSelfCoordinates[i])
                append(lineMain)
                append(lineExtra)
                i += 1
            }
        }
    }
}



