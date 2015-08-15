//
//  WordsToCtxTransitionCtl.swift
//  wordsToCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2015-08-10.
//  Copyright © 2015 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

let screenSize = UIScreen.mainScreen().bounds.size

// WordsView(UITextView) to provide info of start state

// SampleView(UITextView) to mock the end state
func getSampleCtxView(firstGlyphOrigin: CGPoint, words: NSAttributedString, ctx: NSString, containerSize: CGSize = screenSize) -> UITextView {
    
}
// Adjuster(UIScrollView) to transit between words and context
func getAdjuster() -> UIScrollView {
    
}
// MovableOneTextLineView(UIScrollView + UITextView) to compose the animatedContext
func getMovableOneTextLineView(origin: CGPoint, visiableGlyphRange: NSRange, ctx: NSAttributedString) -> MovableOneTextLineView {
    
}



// CtxLinesCtl(a set of functions) to have the lastest info about MovableOneTextLineViews for a certain context and refresh them

func getLinesInfoInWordsView(wordsView: UITextView) -> (glyphRanges: [NSRange], lineRects: [CGRect]) {
    
}

func getLines(glyphRanges: [NSRange], lineRects: [CGRect]) -> [MovableOneTextLineView] {
    
}

// SyncCtl(a set of functions) to control the movement of MovableOneTextLineViews
struct Lines {
    var main: [MovableOneTextLineView]
    var extra: [MovableOneTextLineView]
    
    
    
    func sync(line: MovableOneTextLineView, deltaX: CGFloat) {
        let linesToSync = findLinesToSync(line)
        if linesToSync.count > 0 {
            let baseXs = getBaseXs(linesToSync)
            updateContentOffset(linesToSync, newXs: baseXs.map { $0 + deltaX })
        }
    }
    
    func getBaseXs(lines: [MovableOneTextLineView]) -> [CGFloat] {
        return lines.map { return $0.contentOffset.x }
    }
    
    func findLinesToSync(afterLine: MovableOneTextLineView) -> [MovableOneTextLineView] {
        if let r = findElements(afterLine, inArray: main) {
            return r + findElements(main.indexOf(afterLine)!, inArray: extra)!
        } else {
            return findElements(afterLine, inArray: extra)! + findElements(extra.indexOf(afterLine)!, inArray: main)!
        }
        return [MovableOneTextLineView]()
    }
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

func findTextLines(forBaseContentOffsetXs: [CGFloat], inCtxLines: [MovableOneTextLineView]) -> [MovableOneTextLineView] {
    return inCtxLines.filter { inCtxLines.indexOf($0) > inCtxLines.count - forBaseContentOffsetXs.count - 1 }
}

func updateContentOffset(lines: [MovableOneTextLineView], newXs: [CGFloat]) {
    lines.forEach { $0.contentOffset = CGPointMake(newXs[lines.indexOf($0)!], $0.contentOffset.y) }
}

func refreshMovableOneTextLineView(baseOffsetXs: [CGFloat], deltaOffsetX: CGFloat, lineViews: [MovableOneTextLineView]) {
    lineViews.forEach { $0.contentOffset = CGPointMake(baseOffsetXs[lineViews.indexOf($0)!] + deltaOffsetX, $0.contentOffset.y) }
}

func syncMoves(mainViews: [MovableOneTextLineView], extraViews: [MovableOneTextLineView], animated: Bool = true) {
    for m in mainViews {
        if let i = mainViews.indexOf(m) {
            let next = mainViews.filter{ mainViews.indexOf($0)! > i }
            if next.count == 0 { return }
            let nextExtra = extraViews.filter{ extraViews.indexOf($0)! > i }
            m.baseContentOffsetX = m.contentOffset.x
            updateFollowingViewsBaseContentOffsetX(m, followingViews: next + nextExtra)
            if m.visiableGlyphsRectX < m.contentOffset.x + m.frame.width { // Visiable part is still visiable.
                m.isTrigger = true
                m.extraXTiggered = m.visiableGlyphsRectX - m.contentOffset.x - m.frame.width
                m.setContentOffset(CGPointMake(m.baseContentOffsetX + m.extraXTiggered, m.contentOffset.y), animated: animated) // Animated move synces one by one after the previous one finishes.
                if !animated {
                    syncFollowingViews(m, followingViews: next + nextExtra)
                }
            }
        }
    }
}

class MovableOneTextLineView: UIScrollView {
    let textView: UITextView
    // Used by lineExtraView to hide the visiable part.
    var visiableCharacterRange: NSRange!
    var visiableGlyphRange: NSRange {
        return textView.layoutManager.glyphRangeForCharacterRange(visiableCharacterRange, actualCharacterRange: nil)
    }
    var visiableGlyphsRectX: CGFloat {
        return textView.frame.origin.x + textView.textContainer.lineFragmentPadding + textView.textContainerInset.left + textView.layoutManager.boundingRectForGlyphRange(visiableGlyphRange, inTextContainer: textView.textContainer).origin.x
    }
    init(textViewToInsert: UITextView, rect: CGRect) {
        super.init(frame: rect)
        decelerationRate = UIScrollViewDecelerationRateFast
        contentSize = CGSizeMake(textViewToInsert.frame.width * 3, textViewToInsert.frame.height)
        textView = textViewToInsert
        addSubview(textView)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}