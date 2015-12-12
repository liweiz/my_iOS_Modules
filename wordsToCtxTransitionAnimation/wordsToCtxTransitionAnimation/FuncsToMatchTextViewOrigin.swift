//
//  FuncsToMatchTextViewOrigin.swift
//  wordsToCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2015-11-28.
//  Copyright © 2015 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

// Convert in root view's coordinates.
func textRectOriginInRoot(rootView: UIView, view: UITextView) -> CGPoint {
    return rootView.convertPoint(CGPointMake(view.bounds.origin.x + view.layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.x + view.textContainerInset.left, view.bounds.origin.y + view.layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.y + view.textContainerInset.top), fromView: view)
}

func distancesToMove(from: CGPoint, to: CGPoint) -> CGPoint {
    return CGPointMake(to.x - from.x, to.y - from.y)
}

func textViewOriginInRoot(view: UITextView, textOriginInRoot: CGPoint) -> CGPoint {
    return CGPointMake(textOriginInRoot.x - (view.bounds.origin.x + view.layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.x + view.textContainerInset.left), textOriginInRoot.y - (view.bounds.origin.y + view.layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.y + view.textContainerInset.top))
}