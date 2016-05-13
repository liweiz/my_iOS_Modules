//
//  TransitionModel.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-04-19.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

protocol FloatConvertible {
    func float() -> Float
}

extension CGFloat: FloatConvertible {
    func float() -> Float {
        return Float(self)
    }
}

protocol OneMovableInDirection {
    associatedtype DistanceTypeInDirection: FloatConvertible
    func maxDelta(target: Self.DistanceTypeInDirection) -> Self.DistanceTypeInDirection
}

extension CGFloat: OneMovableInDirection {
    func maxDelta(target: CGFloat) -> CGFloat {
        return target - self
    }
}

// Not able to conform to this protocol FOR NOW. Discussion: http://stackoverflow.com/questions/33332613/is-it-possible-to-add-type-constraints-to-a-swift-protocol-conformance-extension
protocol HasMovablesInDirection: CollectionType {
    associatedtype DistanceTypeInDirection
    func indexOfFirstMovableElementInOrder(targets: [Self.DistanceTypeInDirection]) -> Self.Index?
    func indicesOfMovableElementsInOrder(targets: [Self.DistanceTypeInDirection]) -> Range<Self.Index>
}

protocol ElementsMatchable: CollectionType {
    func rangeMatched(targets: [Self.Generator.Element]) -> Bool
}

// dataflow(in CGFloat): initialXs =[find movables]=> movables =[get min delta]=> deltaToMove =[move movables]=> newXs

extension CollectionType where Self.Generator.Element: OneMovableInDirection, Self.Index == Int {
    // protocol HasMovablesInDirection: CollectionType
    func indexOfFirstMovableElementInOrder(targets: [Self.Generator.Element.DistanceTypeInDirection]) -> Self.Index? {
        for i in startIndex..<endIndex {
            if self[i].maxDelta(targets[i]).float() > Float(0) { return i }
        }
        return nil
    }
    func indicesOfMovableElementsInOrder(targets: [Self.Generator.Element.DistanceTypeInDirection]) -> Range<Self.Index> {
        guard let firstIndex = indexOfFirstMovableElementInOrder(targets) else {
            return startIndex..<startIndex
        }
        for i in firstIndex..<endIndex {
            if self[i].maxDelta(targets[i]).float() == Float(0) {
                return firstIndex..<i
            }
        }
        return firstIndex..<endIndex
    }
    // protocol ElementsMatchable: CollectionType
    func rangeMatched(targets: [Self.Generator.Element.DistanceTypeInDirection]) -> Bool {
        guard count == targets.count else {
            fatalError("Numbers of elements in two CollectionTypes not matched.")
        }
        return true
    }
    
    func maxDeltas(targets: [Self.Generator.Element.DistanceTypeInDirection]) -> [Self.Generator.Element.DistanceTypeInDirection] {
        var deltas: [Self.Generator.Element.DistanceTypeInDirection] = []
        if rangeMatched(targets) {
            var i = targets.startIndex
            for j in startIndex..<endIndex {
                deltas.append(self[j].maxDelta(targets[i]))
                i = i.advancedBy(1)
            }
        }
        return deltas
    }
    
    
}



extension Array {
    func interwine(withArray: Array) -> Array {
        var result: Array = []
        for i in 0..<max(count, withArray.count) {
            if i < count { result.append(self[i]) }
            if i < withArray.count { result.append(withArray[i]) }
        }
        return result
    }
}



typealias XsNow = [CGFloat]

typealias DeltaXsForAllLinesInSingleMove = [CGFloat]

typealias DeltaXs = [DeltaXsForAllLinesInSingleMove]





//struct NumbersInTextCtxHorizontalTransition {
//    let originXsImitatingText: [CGFloat]
//    let originXsImitatingCtx: [CGFloat]
//    let originXsImitatingExtraHidden: [CGFloat]
//    let originXsNow: [CGFloat]
//    func isValid() -> Bool {
//        if originXsImitatingText.count == originXsImitatingCtx.count && originXsImitatingCtx.count == originXsImitatingExtraHidden.count && originXsImitatingExtraHidden.count == originXsNow.count && originXsNow.count > 0 {
//            return true
//        }
//        return false
//    }
//    func makeSureSelfIsValid() {
//        assert(isValid(), "NumbersInTextCtxHorizontalTransition not valid: originXsImitatingText, originXsImitatingCtx, originXsImitatingExtraHidden, originXsNow are supposed to have same number of member(s) and non-empty.")
//    }
//    func makeSureIndexFallsInRange(index: Int) {
//        makeSureSelfIsValid()
//        assert(index >= originXsNow.count || index < 0, "Index for NumbersInTextCtxHorizontalTransition out of range.")
//    }
//    subscript(index: Int) -> (textX: CGFloat, ctxX: CGFloat, extraHiddenX: CGFloat, xNow: CGFloat) {
//        get {
//            makeSureIndexFallsInRange(index)
//            return (originXsImitatingText[index], originXsImitatingCtx[index], originXsImitatingExtraHidden[index], originXsNow[index])
//        }
//    }
//    func maxDeltaNow(atIndex: Int, isForExtra: Bool = false, isReversed: Bool = false) -> CGFloat {
//        makeSureIndexFallsInRange(atIndex)
//        let rightEnd = (isForExtra ? self[atIndex].extraHiddenX : self[atIndex].ctxX)
//        return (rightEnd - self[atIndex].xNow) * (isReversed ? -1 : 1)
//    }
//    func maxDeltaAvailableNow(isForExtra: Bool = false, isReversed: Bool = false) -> (startIndex: Int, endIndex: Int, delta: CGFloat) {
//        makeSureSelfIsValid()
//        let n = originXsNow.count
//        for i in 0..<originXsNow.count {
//            let index = isReversed ? n - (i + 1) : i
//            let deltaNow = maxDeltaNow(index, isForExtra: isForExtra, isReversed: isReversed)
//            
//        }
//    }
//}