//
//  MovableOneTextLineView.swift
//  wordsToCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2015-08-20.
//  Copyright © 2015 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

func refreshMovableOneTextLineView(baseOffsetXs: [CGFloat], deltaOffsetX: CGFloat, lineViews: [MovableOneTextLineView]) {
    lineViews.forEach { $0.contentOffset = CGPointMake(baseOffsetXs[lineViews.indexOf($0)!] + deltaOffsetX, $0.contentOffset.y) }
}

class MovableOneTextLineView: UIScrollView, UIScrollViewDelegate {
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
    func hideVisiablePart(animated: Bool) -> Bool {
        if visiableGlyphsRectX < contentOffset.x + frame.width {
            // Visiable part is still visiable.
            setContentOffset(CGPointMake(visiableGlyphsRectX - frame.width, contentOffset.y), animated: animated)
            return true
        }
        return false
    }
    
}