//
//  DataForTextCtxTransition.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-03-25.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

//struct dataForTextCtxTransition {
//    /// baseView is the root view for this module. All the locations in this module are calculated in the baseView's coordinates.
//    let baseView = UIView(frame: (UIApplication.sharedApplication().keyWindow?.rootViewController?.view.frame)!)
//    /// textView is the UITextView on the text side of the transition.
//    let textView: UITextView
//    var textViewTextRectOriginHere: CGPoint {
//        return baseView.convertPoint(textView.deltaToTextRectOriginFromOrigin, fromView: textView)
//    }
//    var
//    
//    /// ctxView is the UITextView on the context side of the transition.
//    let ctxView = fixedWidthFittedTextView(attributedCtx, width: viewWidth, origin: ctxRectOriginInItsParentCoordinates)
//    let
//    // String attributes
//    let font: UIFont
//    let textGlyphColor: UIColor
//    let nontextGlyphColor: UIColor
//    // Geometry: point
//    let textRectOriginInItsParentCoordinates: CGPoint
//    let ctxRectOriginInItsParentCoordinates: CGPoint
//    // Geometry: size
//    let ctxViewWidth: CGFloat
//    let ctxViewHeightMax: CGFloat
//    // Content
//    let text: String
//    let ctx: String
//    
//    
//    // Both states
//    var attributedText: NSAttributedString {
//        return NSAttributedString(string: text, attributes: ["NSFontAttributeName": font])
//    }
//    var attributedCtx: NSAttributedString {
//        return NSAttributedString(string: ctx, attributes: ["NSFontAttributeName": font])
//    }
//    
//    
//    var lines: [UITextView]
//    func fixedWidthTextView() -> UITextView {
//        let view = UITextView(frame: CGRectMake(origin == nil ? 0 : origin!.x, origin == nil ? 0 : origin!.y, width, baseView.frame.height - ))
//        view.attributedText = attributedText
//        view.contentInset = UIEdgeInsetsZero
//        view.textContainer.lineBreakMode = NSLineBreakMode.ByCharWrapping
//        view.textContainer.lineFragmentPadding = 0
//        view.userInteractionEnabled = false
//        let targetHeight = view.layoutManager.boundingRectForGlyphRange(view.layoutManager.glyphRangeForTextContainer(view.textContainer), inTextContainer: view.textContainer).size.height
//        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.width, targetHeight)
//        return view
//    }
//}

