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
    // textRectOriginInCoordinatesOf converts text's rect origin in another view's coordinates.
    func textRectOriginInCoordinatesOf(view: UIView) -> CGPoint {
        return view.convertPoint(CGPointMake(bounds.origin.x + layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.x + textContainerInset.left, bounds.origin.y + layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.y + textContainerInset.top), fromView: self)
    }
    // originInAnotherCoordinates returns the origin in another coordinates, given the text rect's origin in that coordinates.
    func originInAnotherCoordinates(textRectOriginInAnotherCoordinates: CGPoint) -> CGPoint {
        return CGPointMake(textRectOriginInAnotherCoordinates.x - (bounds.origin.x + layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.x + textContainerInset.left), textRectOriginInAnotherCoordinates.y - (bounds.origin.y + layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.y + textContainerInset.top))
    }
}