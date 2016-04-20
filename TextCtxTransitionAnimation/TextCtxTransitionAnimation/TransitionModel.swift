//
//  TransitionModel.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-04-19.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit


struct NumbersInTextCtxHorizontalTransition {
    let originXsImitatingText: [CGFloat]
    let originXsImitatingCtx: [CGFloat]
    let originXsImitatingExtraHidden: [CGFloat]
    let originXsNow: [CGFloat]
    func isValid() -> Bool {
        if originXsImitatingText.count == originXsImitatingCtx.count && originXsImitatingCtx.count == originXsImitatingExtraHidden.count && originXsImitatingExtraHidden.count == originXsNow.count && originXsNow.count > 0 {
            return true
        }
        return false
    }
    func makeSureSelfIsValid() {
        assert(isValid(), "NumbersInTextCtxHorizontalTransition not valid: originXsImitatingText, originXsImitatingCtx, originXsImitatingExtraHidden, originXsNow are supposed to have same number of member(s) and non-empty.")
    }
    func makeSureIndexFallsInRange(index: Int) {
        makeSureSelfIsValid()
        assert(index >= originXsNow.count || index < 0, "Index for NumbersInTextCtxHorizontalTransition out of range.")
    }
    subscript(index: Int) -> (textX: CGFloat, ctxX: CGFloat, extraHiddenX: CGFloat, xNow: CGFloat) {
        get {
            makeSureIndexFallsInRange(index)
            return (originXsImitatingText[index], originXsImitatingCtx[index], originXsImitatingExtraHidden[index], originXsNow[index])
        }
    }
    func maxDeltaNow(atIndex: Int, isForExtra: Bool = false, isReversed: Bool = false) -> CGFloat {
        makeSureIndexFallsInRange(atIndex)
        let rightEnd = (isForExtra ? self[atIndex].extraHiddenX : self[atIndex].ctxX)
        return (rightEnd - self[atIndex].xNow) * (isReversed ? -1 : 1)
    }
    func maxDeltaAvailableNow(isForExtra: Bool = false, isReversed: Bool = false) -> (startIndex: Int, endIndex: Int, delta: CGFloat) {
        makeSureSelfIsValid()
        for i in 0..<originXsNow.count {
            
        }
    }
}