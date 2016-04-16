//
//  UITextViewExtension.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-03-23.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    /// convertFromTextContainerCoordinatesToSelf converts point in TextContainerCoordinates to self's coordinates
    func convertFromTextContainerCoordinatesToSelf(pointInTextContainerCoordinates: CGPoint) -> CGPoint {
        return CGPointMake(bounds.origin.x + textContainerInset.left + pointInTextContainerCoordinates.x, bounds.origin.y + textContainerInset.top + pointInTextContainerCoordinates.y)
    }
    /// deltaToTextRectOriginFromOrigin
    var deltaToTextRectOriginFromOrigin: CGPoint {
        return CGPointMake(bounds.origin.x + layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.x + textContainerInset.left, bounds.origin.y + layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.y + textContainerInset.top)
    }
    // NSLayoutManager's glyphRangeForBoundingRect
    // Bug: That documentation is incorrect; the glyphRangeForBoundingRect methods currently always return whole lines. http://www.cocoabuilder.com/archive/cocoa/17416-nslayoutmanager-glyphrangeforboundingrect-bug.html
    /// glyphRangeForText returns the glyph range for a given text. It returns nil when no string found or the view has nil or empty text.
    func glyphRangeForText(text: NSString) -> NSRange? {
        if !hasNonEmptyTextContent { return nil }
        let range = (attributedText.string as NSString).rangeOfString(text as String)
        return range.location == NSNotFound ? nil : layoutManager.glyphRangeForBoundingRect(layoutManager.boundingRectForGlyphRange(layoutManager.glyphRangeForCharacterRange(range, actualCharacterRange: nil), inTextContainer: textContainer), inTextContainer: textContainer)
    }
    // view's line break leaves no glyph outside of the visiable area, which means no need to worry about the glyph that is partly or not visiable here.
    var charRangesForEachLine: [NSRange]? {
        return glyphRangesForEachLine?.map { layoutManager.characterRangeForGlyphRange($0, actualGlyphRange: nil) }
    }
    var glyphRangesForEachLine: [NSRange]? {
        return lineFragmentRectForEachLine?.map {layoutManager.glyphRangeForBoundingRect($0, inTextContainer: textContainer)}
    }
    var lineFragmentRectForEachLineNoPadding: [CGRect]? {
        return lineFragmentRectForEachLine?.map { CGRectMake(bounds.origin.x + textContainerInset.left + $0.origin.x + textContainer.lineFragmentPadding, bounds.origin.y + textContainerInset.top + $0.origin.y, $0.size.width - textContainer.lineFragmentPadding * 2, $0.size.height) }
    }
    var lineFragmentRectForEachLine: [CGRect]? {
        if hasNonEmptyTextContent {
            var rects = [CGRect]()
            var currentIndex = 0
            while currentIndex < text.characters.count {
                let rect = lineFragmentRect(currentIndex)!
                if !rects.contains(rect) { rects.append(rect) }
                currentIndex += 1
            }
            return rects
        }
        return nil
    }
    func lineFragmentRect(forCharIndex: Int) -> CGRect? {
        let glyphIndex = layoutManager.glyphIndexForCharacterAtIndex(forCharIndex)
        return layoutManager.isValidGlyphIndex(glyphIndex) ? layoutManager.lineFragmentRectForGlyphAtIndex(glyphIndex, effectiveRange: nil) : nil
    }
    var hasNonEmptyTextContent: Bool {
        guard let content = text else {
            return false
        }
        return content == "" ? false : true
    }
}

