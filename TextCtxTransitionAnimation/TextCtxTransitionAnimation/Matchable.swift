//
//  Matchable.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-03-26.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

protocol Matchable {
    func originToMatch(pointOnAnotherView: CGPoint, anotherView: UIView, pointHere: CGPoint) -> CGPoint
}