//
//  ViewMatcher.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-03-21.
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

extension CGPoint {
    func inRootViewCoordinates(selfView: UIView) -> CGPoint {
        return (UIApplication.sharedApplication().keyWindow?.rootViewController?.view.convertPoint(self, fromView: selfView))!
    }
    // deltaTo returns the distances in both axises from self to another point.
    func deltaTo(point: CGPoint) -> CGPoint {
        return CGPointMake(point.x - x, point.y - y)
    }
}