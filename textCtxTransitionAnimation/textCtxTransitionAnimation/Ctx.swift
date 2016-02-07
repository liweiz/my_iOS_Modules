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

func createLines(firstOrigin: CGPoint, viewToCopy: UITextView) -> Lines? {
    var mainLines = [Line]()
    var extraLines = [Line]()
    let linesInfo = textViewLinesInfo(viewToCopy)
    var characterRanges = [NSRange]()
    if linesInfo.glyphRanges.count > 0 {
        for x in linesInfo.glyphRanges {
            characterRanges.append(viewToCopy.layoutManager.characterRangeForGlyphRange(x, actualGlyphRange: nil))
        }
        let f = CGRectMake(0, 0, linesInfo.lineRects[0].size.width * CGFloat(linesInfo.lineRects.count), linesInfo.lineRects[0].size.height)
        let l = combineRanges(characterRanges)
        var i = 0
        for x in characterRanges {
            let rangeMain = visiableRange(true, wordsCharacterRange: l, lineWordsCharacterRange: x)
            let rangeExtra = visiableRange(false, wordsCharacterRange: l, lineWordsCharacterRange: x)
            let lineTextViewMain = lineTextView(f, attriString: viewToCopy.attributedText, visiableCharRange: rangeMain, color: fontColor)
            let lineTextViewExtra = lineTextView(f, attriString: viewToCopy.attributedText, visiableCharRange: rangeExtra, color: fontColor)
            let lineMain = Line(textViewToInsert: lineTextViewMain, rect: linesInfo.lineRects[i])
            let lineExtra = Line(textViewToInsert: lineTextViewExtra, rect: linesInfo.lineRects[i])
            mainLines.append(lineMain)
            extraLines.append(lineExtra)
            i++
        }
        return Lines(main: mainLines, extra: extraLines, visiableCharacterRanges: characterRanges)
    }
    return nil
}



func lineTextView(frame: CGRect, attriString: NSAttributedString, visiableCharRange: NSRange, color: UIColor) -> UITextView {
    let textViewToAdd = UITextView(frame: frame)
    let s = glyphsVisiabilityWithColor(attriString, charRange: visiableCharRange, color: color)
    s.setAttributes(["NSFontAttributeName": sysFont], range: NSMakeRange(0, s.length))
    textViewToAdd.attributedText = s
    return textViewToAdd
}

// MARK: - Adjust line offset



func offsetAdjustAfterLineFollowDone(lineOffsetInRoot: CGPoint, targetOffsetInRoot: CGPoint, line: UITextView, animated: Bool) {
    let p = distancesToMove(lineOffsetInRoot, to: targetOffsetInRoot)
    if p.x * p.y != 0 {
        line.setContentOffset(p, animated: animated)
    }
}



func updateContentOffsets(lines: [Line], newXs: [CGFloat]) {
    lines.forEach { $0.contentOffset = CGPointMake(newXs[lines.indexOf($0)!], $0.contentOffset.y) }
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

// MARK: - Lines
struct Lines {
    let Lines: [Line]
    var Main: [Line] {
        return pickEvenOrOdd(Lines, pickEven: true)
    }
    var Extra: [Line] {
        return pickEvenOrOdd(Lines, pickEven: false)
    }
    var BaseXs: [CGFloat] {
        return Lines.map { return $0.contentOffset.x }
    }
    let visiableCharacterRanges: [NSRange]
    func sync(withLine: Line, deltaX: CGFloat) {
        let _linesToSync = linesToSync(withLine)
        if _linesToSync.count > 0 {
            let _baseXs = baseXs(_linesToSync)
            updateContentOffsets(_linesToSync, newXs: _baseXs.map { $0 + deltaX })
        }
    }
    
    func startFromInitialToExpected(initialOffsetXs: [CGFloat], expectedOffsetXs: [CGFloat], animated: Bool) -> (mainLeadingXs: [CGFloat], extraLeadingXs: [CGFloat]) {
        var m = [CGFloat]()
        var e = [CGFloat]()
        var i = 0
        for x in initialOffsetXs {
            main[i].setContentOffset(CGPointMake(expectedOffsetXs[i] - x, main[i].contentOffset.y), animated: animated)
        }
    }
    

    
    func linesToSync(afterLine: Line) -> [Line] {
        if let r = findElements(afterLine, inArray: main) {
            return r + findElements(main.indexOf(afterLine)!, inArray: extra)!
        } else {
            return findElements(afterLine, inArray: extra)! + findElements(extra.indexOf(afterLine)!, inArray: main)!
        }
        return [Line]()
    }
    
    func expandIntoCtx() -> [[CGPoint]] {
        
    }
}

func pickEvenOrOdd<T>(fromArray: [T], pickEven: Bool) -> [T] {
    var r = [T]()
    var i = 0
    for t in fromArray {
        if i % 2 == 1 {
            r.append(t)
        }
        i++
    }
    return r
}


