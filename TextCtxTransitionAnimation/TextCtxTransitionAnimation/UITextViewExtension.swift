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
    func makeContentClear(ofCharRange: NSRange) {
        let new = NSMutableAttributedString(attributedString: attributedText!)
        new.addAttribute(NSForegroundColorAttributeName, value: UIColor.clearColor(), range: ofCharRange)
    }

    /// singleLineTextViews return SingleLineTextViews that overlap with each line.
    func singleLineTextViews(ctxView: UITextView? = nil) -> [SingleLineTextView] {
        var singleLineTextViews = [SingleLineTextView]()
        if let rects = lineFragmentRectForEachLineNoPadding {
            let fullTextView = (ctxView == nil ? self : ctxView!)
            var i = 0
            for rect in rects {
                let chars = (text as NSString).substringWithRange(charRangesForEachLine![i])
                print("chars: \(chars)")
                let rangeInFullTextView = (fullTextView.text as NSString).rangeOfString(chars)
                let lineView = SingleLineTextView(attriText: fullTextView.attributedText, lineHeight: rect.height)
                let lineViewImitatedTextRectOriginRaw = lineView.rectOriginForCharRangeInTextContainerCoordinates(rangeInFullTextView)
                let lineViewImitatedTextRectOrigin = lineView.convertFromTextContainerCoordinatesToSelf(lineViewImitatedTextRectOriginRaw)
                let lineCharOriginRaw = rectOriginForCharRangeInTextContainerCoordinates(charRangesForEachLine![i])
                let lineCharOrigin = convertFromTextContainerCoordinatesToSelf(lineCharOriginRaw)
                addSubview(lineView)
                lineView.frame.origin = lineView.originToMatch(lineCharOrigin, anotherView: self, pointHere: lineViewImitatedTextRectOrigin)
                singleLineTextViews.append(lineView)
                i += 1
            }
        }
        return singleLineTextViews
    }
    /// deltaOfOriginXs returns the distance between two origins.
    func deltaOfOrigins(fromCharRange: NSRange, toCharRange: NSRange) -> CGPoint? {
        let length = (text as NSString).length
        if fromCharRange.location + fromCharRange.length > length || toCharRange.location + toCharRange.length > length || fromCharRange.length * toCharRange.length == 0 { return nil }
        let fromOrigin = rectOriginForCharRangeInTextContainerCoordinates(fromCharRange)
        let toOrigin = rectOriginForCharRangeInTextContainerCoordinates(toCharRange)
        return fromOrigin.deltaTo(toOrigin)
    }
    func rectForCharRangeInTextContainerCoordinates(charRange: NSRange) -> CGRect {
        return layoutManager.boundingRectForGlyphRange(layoutManager.glyphRangeForCharacterRange(charRange, actualCharacterRange: nil), inTextContainer: textContainer)
    }
    /// rectOriginForCharRangeInTextContainerCoordinates returns the origin of boundingRectForGlyphRange based on its character range in the textContainer's coordinates.
    func rectOriginForCharRangeInTextContainerCoordinates(charRange: NSRange) -> CGPoint {
        return layoutManager.boundingRectForGlyphRange(layoutManager.glyphRangeForCharacterRange(charRange, actualCharacterRange: nil), inTextContainer: textContainer).origin
    }
    /// firstCharOrigin returns origin in the textView's coordinates.
    var firstCharRectOrigin: CGPoint {
        let b = bounds.origin
        let g = layoutManager.lineFragmentRectForGlyphAtIndex(layoutManager.glyphIndexForCharacterAtIndex(0), effectiveRange: nil).origin
        let i = textContainerInset
        return CGPointMake(b.x + g.x + i.left, b.y + g.y + i.top)
    }
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
    /// textViewLinesInfo returns the visiableGlyphRanges for lines and corresponding rect in one textView's coordinates.
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

