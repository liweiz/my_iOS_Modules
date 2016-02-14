//
//  UITextViewExtension.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-02-03.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    // FirstGlyphOrigin in it's textView's coordinates.
    var firstGlyphRectOrigin: CGPoint {
        let b = bounds.origin
        let g = layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin
        let i = textContainerInset
        return CGPointMake(b.x + g.x + i.left, b.y + g.y + i.top)
    }
    // textRectOriginInCoordinatesOf converts text's rect origin in another view's coordinates.
    func textRectOriginInCoordinatesOf(view: UIView) -> CGPoint {
        return view.convertPoint(CGPointMake(bounds.origin.x + layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.x + textContainerInset.left, bounds.origin.y + layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.y + textContainerInset.top), fromView: self)
    }
    // originInAnotherCoordinates returns the origin in another coordinates, given the text rect's origin in that coordinates.
    func originInAnotherCoordinates(textRectOriginInAnotherCoordinates: CGPoint) -> CGPoint {
        return CGPointMake(textRectOriginInAnotherCoordinates.x - (bounds.origin.x + layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.x + textContainerInset.left), textRectOriginInAnotherCoordinates.y - (bounds.origin.y + layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.y + textContainerInset.top))
    }
    
    // NSLayoutManager's glyphRangeForBoundingRect
    // Bug: That documentation is incorrect; the glyphRangeForBoundingRect methods currently always return whole lines. http://www.cocoabuilder.com/archive/cocoa/17416-nslayoutmanager-glyphrangeforboundingrect-bug.html
    func glyphRangeForText(text: NSAttributedString) -> NSRange {
        let r = (attributedText.string as NSString).rangeOfString(text.string)
        if r.location == NSNotFound {
            return r
        }
        return layoutManager.glyphRangeForBoundingRect(layoutManager.boundingRectForGlyphRange(layoutManager.glyphRangeForCharacterRange(r, actualCharacterRange: nil), inTextContainer: textContainer), inTextContainer: textContainer)
    }
    // textViewLinesInfo returns the visiableGlyphRanges for lines and corresponding rect in one textView's coordinates.
    // view's line break leaves no glyph outside of the visiable area, which means no need to worry about the glyph that is partly or not visiable here.
    func linesInfo() -> (glyphRanges: [NSRange], lineRects: [CGRect]) {
        var glyphRanges = [NSRange]()
        var lineRects = [CGRect]()
        let gRange = glyphRangeForText(attributedText)
        if gRange.location != NSNotFound {
            if gRange.length > 0 {
                var lastRect = CGRectZero
                while gRange.location + gRange.length > (glyphRanges.count > 0 ? glyphRanges.last!.location + glyphRanges.last!.length : 0) {
                    let lineGlyphRange = layoutManager.glyphRangeForBoundingRect(CGRectMake(0, lastRect.maxY + 1, 1, 1), inTextContainer: textContainer)
                    lastRect = layoutManager.boundingRectForGlyphRange(lineGlyphRange, inTextContainer: textContainer)
                    lastRect = CGRectMake(lastRect.origin.x + bounds.origin.x + textContainerInset.left + textContainer.lineFragmentPadding, lastRect.origin.y + bounds.origin.y + textContainerInset.top, lastRect.size.width, lastRect.size.height)
                    if NSIntersectionRange(lineGlyphRange, gRange).length > 0 {
                        glyphRanges.append(lineGlyphRange)
                        lineRects.append(lastRect)
                    }
                }
            }
        }
        return (glyphRanges, lineRects)
    }
    // GlyphOriginMatchingPoint is in superView's coordinates.
    func originToMatch(glyphOriginMatchingPoint: CGPoint) -> CGPoint {
        let b = bounds.origin
        let g = layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin
        let i = textContainerInset
        let p = convertPoint(glyphOriginMatchingPoint, fromView: superview)
        return CGPointMake(p.x - b.x - g.x - i.left, p.y - b.y - g.y - i.top)
    }
    
}