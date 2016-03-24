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
    /// rectOriginForCharacterRangeInTextContainerCoordinates returns the origin of boundingRectForGlyphRange based on its character range in the textContainer's coordinates.
    func rectOriginForCharacterRangeInTextContainerCoordinates(characterRange: NSRange) -> CGPoint {
        return layoutManager.boundingRectForGlyphRange(layoutManager.glyphRangeForCharacterRange(characterRange, actualCharacterRange: nil), inTextContainer: textContainer).origin
    }
    /// firstGlyphOrigin returns origin in the textView's coordinates.
    var firstGlyphRectOrigin: CGPoint {
        let b = bounds.origin
        let g = layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin
        let i = textContainerInset
        return CGPointMake(b.x + g.x + i.left, b.y + g.y + i.top)
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
    /// textViewLinesInfo returns the visiableGlyphRanges for lines and corresponding rect in one textView's coordinates.
    // view's line break leaves no glyph outside of the visiable area, which means no need to worry about the glyph that is partly or not visiable here.
    var characterRangesForEachLine: [NSRange]? {
        return glyphRangesForEachLine?.map { layoutManager.characterRangeForGlyphRange($0, actualGlyphRange: nil) }
    }
    var glyphRangesForEachLine: [NSRange]? {
        return lineFragmentRectForEachLine?.map {layoutManager.glyphRangeForBoundingRect($0, inTextContainer: textContainer)}
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
    func lineFragmentRect(forCharacterIndex: Int) -> CGRect? {
        let glyphIndex = layoutManager.glyphIndexForCharacterAtIndex(forCharacterIndex)
        return layoutManager.isValidGlyphIndex(glyphIndex) ? layoutManager.lineFragmentRectForGlyphAtIndex(glyphIndex, effectiveRange: nil) : nil
    }
    var hasNonEmptyTextContent: Bool {
        guard let content = text else {
            return false
        }
        return content == "" ? false : true
    }
}

