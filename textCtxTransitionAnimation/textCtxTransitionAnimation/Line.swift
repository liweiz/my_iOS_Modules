//
//  Line.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-01-31.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

class Line: UIScrollView, UIScrollViewDelegate {
    var textView = UITextView(frame: CGRectMake(0, 0, 0, 0))
    // Properties for vislable glyphs.
    var visiableCharacterRange: NSRange!
    var visiableGlyphRange: NSRange {
        return textView.layoutManager.glyphRangeForCharacterRange(visiableCharacterRange, actualCharacterRange: nil)
    }
    var visiableGlyphsRectX: CGFloat {
        return textView.frame.origin.x + textView.textContainer.lineFragmentPadding + textView.textContainerInset.left + textView.layoutManager.boundingRectForGlyphRange(visiableGlyphRange, inTextContainer: textView.textContainer).origin.x
    }
    var visiableGlyphsRectRightEndX: CGFloat {
        return visiableGlyphsRectX + textView.layoutManager.boundingRectForGlyphRange(visiableGlyphRange, inTextContainer: textView.textContainer).width
    }
    var visiableGlyphsIsHidden: Bool {
        return (visiableGlyphsRectX >= contentOffset.x + contentSize.width) || (visiableGlyphsRectRightEndX <= contentOffset.x) ? true : false
    }
    var offsetForLeftState = CGPointZero
    var offsetForRightState = CGPointZero
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
    // scrollToAnotherState scrolls view and returns delta on x axis.
    func scrollToAnotherState(newOffset: CGPoint, animated: Bool) -> CGFloat {
        let oldX = newOffset.x
        setContentOffset(newOffset, animated: animated)
        return newOffset.x - oldX
    }
    func scrollToRightToHideVisiableGlyphs(animated: Bool) -> Bool {
        if !visiableGlyphsIsHidden {
            setContentOffset(CGPointMake(contentOffsetXToHideVisiableGlyphsWhenScrolledToRight, contentOffset.y), animated: animated)
            return true
        }
        return false
    }
    func scrollToLeftToShowVisiableGlyphs(animated: Bool, newOffsetX: CGFloat) -> Bool {
        if visiableGlyphsIsHidden {
            setContentOffset(CGPointMake(newOffsetX, contentOffset.y), animated: animated)
            return true
        }
        return false
    }
    var contentOffsetXToHideVisiableGlyphsWhenScrolledToRight: CGFloat {
        return visiableGlyphsRectX - contentSize.width
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        scrollAnimationDone = true
    }
    var scrollAnimationDone = false
}

//func transit(main: Line, extra: Line, initialOffsetX: CGFloat, expectedOffsetX: CGFloat, animated: Bool) -> (mainLeadingX: CGFloat, extraLeadingX: CGFloat) {
//    main.setContentOffset(CGPointMake(expectedOffsetX - initialOffsetX, main.contentOffset.y), animated: animated)
//    
//}

