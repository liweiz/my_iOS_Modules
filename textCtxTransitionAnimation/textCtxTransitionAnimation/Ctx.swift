//
//  Ctx.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-02-04.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

let fontColor = UIColor.blueColor()
let sysFont = UIFont.systemFontOfSize(16)
//  Each line when it leads the move of following lines has two phases of sliding: 1) matching the line start of the textview it copies 2) hiding the extra part of the line that is not supposed to be shown in the line.

var initialOffsetXs = [CGFloat]()
var mainLeadingXs = [CGFloat]()
var extraLeadingXs = [CGFloat]()




func lineTextView(frame: CGRect, attriString: NSAttributedString, visiableCharRange: NSRange, color: UIColor) -> UITextView {
    let textViewToAdd = UITextView(frame: frame)
    let s = glyphsVisiabilityWithColor(attriString, charRange: visiableCharRange, color: color)
    s.setAttributes(["NSFontAttributeName": sysFont], range: NSMakeRange(0, s.length))
    textViewToAdd.attributedText = s
    return textViewToAdd
}

// updateContentOffsets adjusts offsets for lines
func updateContentOffsets(lines: [Line], newXs: [CGFloat]) {
    lines.forEach { $0.contentOffset = CGPointMake(newXs[lines.indexOf($0)!], $0.contentOffset.y) }
}

// MARK: - Line geometric/character/glyph info
func expectedOffsetXsForLines(textViews: [UITextView], glyphRangesForLines: [NSRange]) -> [CGFloat] {
    var r = [CGFloat]()
    var i = Int(0)
    for v in textViews {
        let boundingRect = v.layoutManager.boundingRectForGlyphRange(glyphRangesForLines[i], inTextContainer: v.textContainer)
        r.append(boundingRect.origin.x)
        i++
    }
    return r
}




