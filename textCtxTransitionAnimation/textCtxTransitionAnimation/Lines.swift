//
//  Lines.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-01-31.
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
// We use [CGPoint] as the data container to record each line's move on each step. There is a [[CGPoint]] used as a container to record all the moves each line takes for all the steps.
func initialOffsetX(contentViewWidth: CGFloat, noOfLines: Int) -> [CGFloat] {
    var r = [CGFloat]()
    for var i = 0; i < noOfLines; i++ {
        r.append(contentViewWidth * CGFloat(i))
    }
    return r
}


func offsetAdjustAfterLineFollowDone(lineOffsetInRoot: CGPoint, targetOffsetInRoot: CGPoint, line: UITextView, animated: Bool) {
    let p = distancesToMove(lineOffsetInRoot, to: targetOffsetInRoot)
    if p.x * p.y != 0 {
        line.setContentOffset(p, animated: animated)
    }
}

// offsetToFollowAboveLine can only be used for lines made of the same UIScrollView structure.
func offsetToFollowAboveLine(aboveLineOffset: CGPoint, aboveLineSize: CGSize) -> CGPoint {
    return CGPointMake(aboveLineOffset.x + aboveLineSize.width, aboveLineOffset.y + aboveLineSize.height)
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

func linesRects(firstOrigin: CGPoint, linesRectsInTextView: [CGRect]) -> [CGRect] {
    var r = [CGRect]()
    let d = distancesToMove(linesRectsInTextView[0].origin, to: firstOrigin)
    if d.x * d.y != 0 {
        for x in linesRectsInTextView {
            r.append(CGRect(x: x.origin.x + d.x, y: x.origin.y + d.y, width: x.size.width, height: x.size.height))
        }
    }
    return r
}

// NSLayoutManager's glyphRangeForBoundingRect bug: That documentation is incorrect; the glyphRangeForBoundingRect methods currently always return whole lines. http://www.cocoabuilder.com/archive/cocoa/17416-nslayoutmanager-glyphrangeforboundingrect-bug.html
func glyphRangeForText(text: NSAttributedString, view: UITextView) -> NSRange {
    let r = (view.attributedText.string as NSString).rangeOfString(text.string)
    if r.location == NSNotFound {
        return r
    }
    return view.layoutManager.glyphRangeForBoundingRect(view.layoutManager.boundingRectForGlyphRange(view.layoutManager.glyphRangeForCharacterRange(r, actualCharacterRange: nil), inTextContainer: view.textContainer), inTextContainer: view.textContainer)
}

// textViewLinesInfo returns the visiableGlyphRanges for lines and corresponding rect in one textView's coordinates.
// view's line break leaves no glyph outside of the visiable area, which means no need to worry about the glyph that is partly or not visiable here.
func textViewLinesInfo(view: UITextView) -> (glyphRanges: [NSRange], lineRects: [CGRect]) {
    var glyphRanges = [NSRange]()
    var lineRects = [CGRect]()
    let gRange = glyphRangeForText(view.attributedText, view: view)
    if gRange.location != NSNotFound {
        if gRange.length > 0 {
            var lastRect = CGRectZero
            while gRange.location + gRange.length > (glyphRanges.count > 0 ? glyphRanges.last!.location + glyphRanges.last!.length : 0) {
                let lineGlyphRange = view.layoutManager.glyphRangeForBoundingRect(CGRectMake(0, lastRect.maxY + 1, 1, 1), inTextContainer: view.textContainer)
                lastRect = view.layoutManager.boundingRectForGlyphRange(lineGlyphRange, inTextContainer: view.textContainer)
                lastRect = CGRectMake(lastRect.origin.x + view.bounds.origin.x + view.textContainerInset.left + view.textContainer.lineFragmentPadding, lastRect.origin.y + view.bounds.origin.y + view.textContainerInset.top, lastRect.size.width, lastRect.size.height)
                if NSIntersectionRange(lineGlyphRange, gRange).length > 0 {
                    glyphRanges.append(lineGlyphRange)
                    lineRects.append(lastRect)
                }
            }
        }
    }
    return (glyphRanges, lineRects)
}

func glyphsVisiabilityWithColor(aString: NSAttributedString, charRange: NSRange, color: UIColor) -> NSMutableAttributedString {
    let s = NSMutableAttributedString(attributedString: aString)
    s.addAttribute(NSForegroundColorAttributeName, value: UIColor.clearColor(), range: NSMakeRange(0, (s.string as NSString).length))
    s.addAttribute(NSForegroundColorAttributeName, value: color, range: charRange)
    return s
}

func visiableRange(isForMain: Bool, wordsCharacterRange: NSRange, lineWordsCharacterRange: NSRange) -> NSRange {
    return isForMain ? NSMakeRange(wordsCharacterRange.location, lineWordsCharacterRange.location + lineWordsCharacterRange.length - 1) : NSMakeRange(lineWordsCharacterRange.location + lineWordsCharacterRange.length, wordsCharacterRange.location + wordsCharacterRange.length - 1)
}

// GlyphOriginMatchingPoint is in superView's coordinates.
func getTextViewOrigin(view: UITextView, glyphOriginMatchingPoint: CGPoint) -> CGPoint {
    let b = view.bounds.origin
    let g = view.layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin
    let i = view.textContainerInset
    let p = view.convertPoint(glyphOriginMatchingPoint, fromView: view.superview)
    return CGPointMake(p.x - b.x - g.x - i.left, p.y - b.y - g.y - i.top)
}

// FirstGlyphOrigin in it's textView's coordinates.
func textViewFirstGlyphOrigin(view: UITextView) -> CGPoint {
    let b = view.bounds.origin
    let g = view.layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin
    let i = view.textContainerInset
    return CGPointMake(b.x + g.x + i.left, b.y + g.y + i.top)
}



// MARK: - Lines
struct Lines {
    var main: [Line]
    var extra: [Line]
    var visiableCharacterRanges: [NSRange]
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
    
    func baseXs(lines: [Line]) -> [CGFloat] {
        return lines.map { return $0.contentOffset.x }
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

// MARK: - Utility
func combineRanges(ranges: [NSRange]) -> NSRange {
    if ranges.count > 0 {
        var l = 0
        for x in ranges {
            l = l + x.length
        }
        return NSMakeRange(ranges.first!.location, l)
    }
    return NSMakeRange(0, 0)
}

func findElements<T: Equatable>(beyondElement: T, inArray: [T]) -> [T]? {
    if let i = inArray.indexOf(beyondElement) {
        return inArray.filter { inArray.indexOf($0) > i }
    }
    return nil
}

func findElements<T: Equatable>(beyondIndex: Int, inArray: [T]) -> [T]? {
    return inArray.count > beyondIndex ? inArray.filter { inArray.indexOf($0) > beyondIndex } : nil
}