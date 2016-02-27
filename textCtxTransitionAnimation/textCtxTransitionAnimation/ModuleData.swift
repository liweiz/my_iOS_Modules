//
//  ModuleData.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-01-31.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

struct dataForTextCtxTransition {
    // String attributes
    let font: UIFont
    let textGlyphColor: UIColor
    let nontextGlyphColor: UIColor
    // Geometry: point
    let textRectOriginInItsParentCoordinates: CGPoint
    let ctxRectOriginInItsParentCoordinates: CGPoint
    // Geometry: size
    let viewWidth: CGFloat
    let maxHeight: CGFloat
    // Content
    let text: String
    let ctx: String
    
    
    var lines = [Line]()
    var deltaXs = [CGFloat]()
    // Both states
    var attributedText: NSAttributedString {
        return NSAttributedString(string: text, attributes: ["NSFontAttributeName": font])
    }
    var attributedCtx: NSAttributedString {
        return NSAttributedString(string: ctx, attributes: ["NSFontAttributeName": font])
    }
    var textViewToImitate: UITextView {
        return fixedWidthFittedTextView(attributedText, width: viewWidth, origin: textRectOriginInItsParentCoordinates)
    }
    var ctxViewToImitate: UITextView {
        return fixedWidthFittedTextView(attributedCtx, width: viewWidth, origin: ctxRectOriginInItsParentCoordinates)
    }
    
}

func fixedWidthFittedTextView(attributedText: NSAttributedString, width: CGFloat, origin: CGPoint?) -> UITextView {
    let view = UITextView(frame: CGRectMake(origin == nil ? 0 : origin!.x, origin == nil ? 0 : origin!.y, width, 1000))
    view.attributedText = attributedText
    view.contentInset = UIEdgeInsetsZero
    view.textContainer.lineBreakMode = NSLineBreakMode.ByCharWrapping
    view.textContainer.lineFragmentPadding = 0
    view.userInteractionEnabled = false
    let targetHeight = view.layoutManager.boundingRectForGlyphRange(view.layoutManager.glyphRangeForTextContainer(view.textContainer), inTextContainer: view.textContainer).size.height
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.width, targetHeight)
    return view
}

// For each line the main moves first and the extra and following lines sync their offset.x with the main. Then the extra moves to adjust visiability, if it is needed.
// The extra's adjustment is to hide the unwanted glyph(s). So after the adjustment finishes, the first hidden  glyph's rect.x must be in the same position as the line view's in the parent view's coordinates. Hence, there is no need to adjust the next line's main to make it's first visiable glyph's rect.x at the same position as the line's rect.x.
// So we can use an array to store the whole change by storing the first element as the first line's main change, the second element as the first line's extra change and so on. Those with no need of change just stored as a 0.