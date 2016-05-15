//
//  TransitionModel.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-04-19.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

protocol NumericType: Comparable {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    func %(lhs: Self, rhs: Self) -> Self
    var zero: Self { get }
}

extension NumericType {
    var zero: Self {
        return self - self
    }
}

extension Double: NumericType {}
extension Float: NumericType {}
extension Int: NumericType {}
extension Int8: NumericType {}
extension Int16: NumericType {}
extension Int32: NumericType {}
extension Int64: NumericType {}
extension UInt: NumericType {}
extension UInt8: NumericType {}
extension UInt16: NumericType {}
extension UInt32: NumericType {}
extension UInt64: NumericType {}
extension CGFloat: NumericType {}

protocol MovableInDirection {
    associatedtype DistanceTypeInDirection: NumericType
    var valueInDirection: Self.DistanceTypeInDirection { get }
    @warn_unused_result func maxDelta(target: Self.DistanceTypeInDirection) -> Self.DistanceTypeInDirection
    @warn_unused_result func updated(byDelta: Self.DistanceTypeInDirection) -> Self.DistanceTypeInDirection
}

extension CGFloat: MovableInDirection {
    var valueInDirection: CGFloat {
        return self
    }
    @warn_unused_result func maxDelta(target: CGFloat) -> CGFloat {
        return target - self
    }
    @warn_unused_result func updated(byDelta: CGFloat) -> CGFloat {
        return self + byDelta
    }
}

protocol ElementsMatchable: CollectionType {
    @warn_unused_result func rangeMatched(targets: [Self.Generator.Element]) -> Bool
}

// protocol ElementsMatchable: CollectionType
extension CollectionType where Self.Generator.Element: MovableInDirection, Self.Index == Int {
    @warn_unused_result func rangeMatched(targets: [Self.Generator.Element.DistanceTypeInDirection]) -> Bool {
        guard count == targets.count else {
            fatalError("Numbers of elements in two CollectionTypes not matched.")
        }
        return true
    }
}

protocol IndexMatchable: Indexable {
    @warn_unused_result func index(inRangeInt: Range<Int>, indexInSelf: Self.Index) -> Int?
}

extension CollectionType {
    @warn_unused_result func index(inRangeInt: Range<Int>, indexInSelf: Self.Index) -> Int? {
        if inRangeInt.startIndex == inRangeInt.endIndex { return nil }
        var j = inRangeInt.startIndex
        var isContained = false
        var doneAdding = false
        for i in startIndex...indexInSelf {
            if j < inRangeInt.endIndex {
                j = j.advancedBy(1)
            } else {
                doneAdding = true
            }
            if i == indexInSelf { isContained = true }
            if isContained && doneAdding { return j }
        }
        return nil
    }
}

// dataflow(in CGFloat): initialXs =[find movables]=> movables =[get min delta]=> deltaToMove =[move movables]=> newXs
// Not able to conform to this protocol FOR NOW. Discussion: http://stackoverflow.com/questions/33332613/is-it-possible-to-add-type-constraints-to-a-swift-protocol-conformance-extension
protocol HasMovablesInDirection: CollectionType {
    associatedtype DistanceTypeInDirection
    @warn_unused_result func indexOfFirstMovableElementInOrder(targets: [Self.DistanceTypeInDirection]) -> Self.Index?
    @warn_unused_result func indicesOfMovableElementsInOrder(targets: [Self.DistanceTypeInDirection]) -> Range<Self.Index>?
    @warn_unused_result func maxDeltas(targets: [Self.DistanceTypeInDirection]) -> [Self.DistanceTypeInDirection]
    @warn_unused_result func maxDeltaNow(targets: [Self.DistanceTypeInDirection]) -> Self.DistanceTypeInDirection?
}

// protocol HasMovablesInDirection: CollectionType
extension CollectionType where Self.Generator.Element: MovableInDirection, Self.Index == Int {
    func indexOfFirstMovableElementInOrder(targets: [Self.Generator.Element.DistanceTypeInDirection]) -> Self.Index? {
        for i in startIndex..<endIndex {
            if self[i].maxDelta(targets[i]) > targets[i].zero { return i }
        }
        return nil
    }
    func indicesOfMovableElementsInOrder(targets: [Self.Generator.Element.DistanceTypeInDirection]) -> Range<Self.Index>? {
        guard let firstIndex = indexOfFirstMovableElementInOrder(targets) else {
            return nil
        }
        for i in firstIndex..<endIndex {
            if self[i].maxDelta(targets[i]) == targets[i].zero {
                return firstIndex..<i
            }
        }
        return firstIndex..<endIndex
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
    func maxDeltaNow(targets: [Self.Generator.Element.DistanceTypeInDirection]) -> Self.Generator.Element.DistanceTypeInDirection? {
        guard let movableRange = indicesOfMovableElementsInOrder(targets) else { return nil }
        let movables = self[movableRange] as! Self
        guard let i = index(targets.startIndex..<targets.endIndex, indexInSelf: movableRange.startIndex) else { return nil }
        guard let j = index(targets.startIndex..<targets.endIndex, indexInSelf: movableRange.endIndex) else { return nil }
        let t = Array(targets[i..<j])
        var deltas: [Self.Generator.Element.DistanceTypeInDirection] = []
        if rangeMatched(t) {
            var k = t.startIndex
            for l in movables.startIndex..<movables.endIndex {
                deltas.append(movables[l].maxDelta(t[k]))
                k = k.advancedBy(1)
            }
        }
        return deltas.minElement({ $0 < $1 })
    }
    func changesToReachAllTargets(targets: [Self.Generator.Element.DistanceTypeInDirection]) -> (deltas: [Self.Generator.Element.DistanceTypeInDirection], ranges: [Range<Self.Index>]) {
        var deltas: [Self.Generator.Element.DistanceTypeInDirection] = []
        var ranges: [Range<Self.Index>] = []
        var values: [Self.Generator.Element.DistanceTypeInDirection] = []
        var d: Self.Generator.Element.DistanceTypeInDirection? = nil
        while d == nil || d! != d!.zero {
            let newBase = deltas.reduce(Float(0), combine: $0.)
            guard let now = base..maxDeltaNow(targets) else {
                
            }
        }
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