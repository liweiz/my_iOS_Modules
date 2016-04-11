//
//  Animatable.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-04-09.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

protocol Animatable {
//    var animateOnSingleAxis: (fromPosition: CGFloat, toPosition: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, completion: ((Bool) -> Void)?)? { get set }
    func startHorizontalAnimation(fromPosition: CGFloat, toPosition: CGFloat)
    func startVerticalAnimation(fromPosition: CGFloat, toPosition: CGFloat)
    func pauseHorizontalAnimation()
}