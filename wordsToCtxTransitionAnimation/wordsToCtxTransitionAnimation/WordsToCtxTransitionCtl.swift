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

class MovableOneTextLineView: UIScrollView {
    let textView: UITextView
    // Initial contentOffset on x-axis.
    let baseContentOffsetX: CGFloat
    // Store distance moved triggered by this on x-axis.
    var extraXTiggered = CGFloat(0)
    var isTrigger = false
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

// CtxLinesCtl(a set of functions) to have the lastest info about MovableOneTextLineViews for a certain context and refresh them
func getLinesInfoInWordsView(wordsView: UITextView) -> (glyphRanges: [NSRange], lineRects: [CGRect]) {
    
}

func getLines(glyphRanges: [NSRange], lineRects: [CGRect]) -> [MovableOneTextLineView] {
    
}

// SyncCtl(a set of functions) to control the movement of MovableOneTextLineViews
func refreshBaseContentOffsetXs()

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