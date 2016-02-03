//
//  FuncsToMatchTextViewOrigin.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-02-01.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

// distancesToMove returns the distances in both axises from one to another point.
func distancesToMove(from: CGPoint, to: CGPoint) -> CGPoint {
    return CGPointMake(to.x - from.x, to.y - from.y)
}