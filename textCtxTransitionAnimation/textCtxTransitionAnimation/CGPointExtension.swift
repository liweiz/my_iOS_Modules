//
//  CGPointExtension.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-02-07.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    func inRootViewCoordinates(selfView: UIView) -> CGPoint {
        return (UIApplication.sharedApplication().keyWindow?.rootViewController?.view.convertPoint(self, fromView: selfView))!
    }
    // deltaTo returns the distances in both axises from self to another point.
    func deltaTo(point: CGPoint) -> CGPoint {
        return CGPointMake(point.x - x, point.y - y)
    }
}