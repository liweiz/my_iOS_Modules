//
//  UIViewExtension.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-02-08.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func originOfAnotherViewToOverlapTwoPoints(pointInSelf: CGPoint, pointInAnotherView: CGPoint, anotherView: UIView) -> CGPoint {
        let pointInAnotherViewProjectedToSelf = convertPoint(pointInAnotherView, fromView: anotherView)
        let delta = pointInAnotherViewProjectedToSelf.deltaTo(pointInSelf)
        return CGPointMake(anotherView.frame.origin.x + delta.x, anotherView.frame.origin.y + delta.y)
    }
}