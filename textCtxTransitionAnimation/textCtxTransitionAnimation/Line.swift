//
//  Line.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-01-31.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

func refreshLine(baseOffsetXs: [CGFloat], deltaOffsetX: CGFloat, lines: [Line]) {
    lines.forEach { $0.contentOffset = CGPointMake(baseOffsetXs[lines.indexOf($0)!] + deltaOffsetX, $0.contentOffset.y) }
}

class Line: UIScrollView, UIScrollViewDelegate {
    var textView = UITextView(frame: CGRectMake(0, 0, 0, 0))
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
    func hideVisiablePart(animated: Bool) -> Bool {
        if visiableGlyphsRectX < contentOffset.x + frame.width {
            // Visiable part is still visiable.
            setContentOffset(CGPointMake(contentOffsetXHidesVisiablePart(frame.width, visiableGlyphsRectX: visiableGlyphsRectX), contentOffset.y), animated: animated)
            return true
        }
        return false
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isEqual(self) {
            
        }
    }
    
}

func transit(main: Line, extra: Line, initialOffsetX: CGFloat, expectedOffsetX: CGFloat, animated: Bool) -> (mainLeadingX: CGFloat, extraLeadingX: CGFloat) {
    main.setContentOffset(CGPointMake(expectedOffsetX - initialOffsetX, main.contentOffset.y), animated: animated)
    
}

func contentOffsetXHidesVisiablePart(viewWidth: CGFloat, visiableGlyphsRectX: CGFloat) -> CGFloat {
    return visiableGlyphsRectX - viewWidth
}