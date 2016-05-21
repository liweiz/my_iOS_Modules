//
//  TransitionModel.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-04-19.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

//import Foundation
//import UIKit
//
//protocol NumericType: Comparable {
//    func +(lhs: Self, rhs: Self) -> Self
//    func -(lhs: Self, rhs: Self) -> Self
//    func *(lhs: Self, rhs: Self) -> Self
//    func /(lhs: Self, rhs: Self) -> Self
//    func %(lhs: Self, rhs: Self) -> Self
//    var zero: Self { get }
//}
//
//extension NumericType {
//    var zero: Self {
//        return self - self
//    }
//}
//
//protocol MovableInDirection {
//    associatedtype DistanceTypeInDirection: NumericType
//    var valueInDirection: Self.DistanceTypeInDirection { get }
//    @warn_unused_result func maxDelta(target: Self.DistanceTypeInDirection) -> Self.DistanceTypeInDirection
//    @warn_unused_result func updated(byDelta: Self.DistanceTypeInDirection) -> Self.DistanceTypeInDirection
//}
//
//protocol NumericTypeInDirection: NumericType, MovableInDirection {
//    associatedtype DistanceTypeInDirection: NumericType = Self
//}
//
//extension NumericTypeInDirection {
//    var valueInDirection: Self {
//        return self
//    }
//    @warn_unused_result func maxDelta(target: Self) -> Self {
//        return target - self
//    }
//    @warn_unused_result func updated(byDelta: Self) -> Self {
//        return self + byDelta
//    }
//}
//
//extension Double: NumericTypeInDirection {}
//extension Float: NumericTypeInDirection {}
//extension Int: NumericTypeInDirection {}
//extension Int8: NumericTypeInDirection {}
//extension Int16: NumericTypeInDirection {}
//extension Int32: NumericTypeInDirection {}
//extension Int64: NumericTypeInDirection {}
//extension UInt: NumericTypeInDirection {}
//extension UInt8: NumericTypeInDirection {}
//extension UInt16: NumericTypeInDirection {}
//extension UInt32: NumericTypeInDirection {}
//extension UInt64: NumericTypeInDirection {}
//extension CGFloat: NumericTypeInDirection {}
//
//protocol ElementsMatchable: CollectionType {
//    @warn_unused_result func okToProceed(withArrayWithNumberOfElem: Int) -> Bool
//}
//
//// protocol ElementsMatchable: CollectionType
//extension CollectionType where Self.Generator.Element: MovableInDirection, Self.Index == Int {
//    @warn_unused_result func okToProceed(withArrayWithNumberOfElem: Int) -> Bool {
//        guard count == withArrayWithNumberOfElem else {
//            fatalError("Not able to work with array with different number of elements.")
//        }
//        return true
//    }
//}
//
//protocol IndexMatchable: Indexable {
//    @warn_unused_result func index(inRangeInt: Range<Int>, indexInSelf: Self.Index) -> Int?
//}
//
//extension CollectionType {
//    @warn_unused_result func correspondingIndex(inRangeInt: Range<Int>, forIndexInSelf: Self.Index) -> Int? {
//        if inRangeInt.startIndex == inRangeInt.endIndex { return nil }
//        var j = inRangeInt.startIndex
//        var isContained = false
//        var doneAdding = false
//        for i in startIndex...forIndexInSelf {
//            if j < inRangeInt.endIndex && i != forIndexInSelf {
//                j = j.advancedBy(1)
//            } else {
//                doneAdding = true
//            }
//            if i == forIndexInSelf { isContained = true }
//            if isContained && doneAdding { return j }
//        }
//        return nil
//    }
//}
//
//// dataflow(in CGFloat): initialXs =[find movables]=> movables =[get min delta]=> deltaToMove =[move movables]=> newXs
//// Not able to conform to this protocol FOR NOW. Discussion: http://stackoverflow.com/questions/33332613/is-it-possible-to-add-type-constraints-to-a-swift-protocol-conformance-extension
//protocol HasMovablesInDirection: CollectionType {
//    associatedtype DistanceTypeInDirection
//    @warn_unused_result func indexOfFirstMovableElementInOrder(targets: [Self.DistanceTypeInDirection]) -> Self.Index?
//    @warn_unused_result func indicesOfMovableElementsInOrder(targets: [Self.DistanceTypeInDirection]) -> Range<Self.Index>?
//    @warn_unused_result func maxDeltas(targets: [Self.DistanceTypeInDirection]) -> [Self.DistanceTypeInDirection]
//    @warn_unused_result func maxDeltaNow(targets: [Self.DistanceTypeInDirection]) -> (delta: Self.DistanceTypeInDirection?, range: Range<Self.Index>)?
//    @warn_unused_result func update(range: Range<Self.Index>, withDelta: Self.DistanceTypeInDirection) -> [Self.DistanceTypeInDirection]?
//    @warn_unused_result func deltasOfEachMoveToReachTargets(targets: [Self.DistanceTypeInDirection], existingDeltas: [Self.DistanceTypeInDirection]) -> [Self.DistanceTypeInDirection]?
//}
//
//extension CollectionType where Self.Generator.Element: NumericTypeInDirection, Self.Index == Int {
//    @warn_unused_result func indexOfFirstMovableElementInOrder(targets: [Self.Generator.Element]) -> Self.Index? {
//        for i in startIndex..<endIndex {
//            if self[i].maxDelta(targets[i]) > targets[i].zero { return i }
//        }
//        return nil
//    }
//    @warn_unused_result func indicesOfMovableElementsInOrder(targets: [Self.Generator.Element]) -> Range<Self.Index>? {
//        guard let firstIndex = indexOfFirstMovableElementInOrder(targets) else {
//            return nil
//        }
//        for i in firstIndex..<endIndex {
//            if self[i].maxDelta(targets[i]) == targets[i].zero {
//                return firstIndex..<i
//            }
//        }
//        return firstIndex..<endIndex
//    }
//    @warn_unused_result func maxDeltas(targets: [Self.Generator.Element]) -> [Self.Generator.Element] {
//        var deltas: [Self.Generator.Element] = []
//        if okToProceed(targets.count) {
//            var i = targets.startIndex
//            for j in startIndex..<endIndex {
//                deltas.append(self[j].maxDelta(targets[i]))
//                i = i.advancedBy(1)
//            }
//        }
//        return deltas
//    }
//    @warn_unused_result func maxDeltaNow(targets: [Self.Generator.Element]) -> (delta: Self.Generator.Element?, range: Range<Self.Index>)? {
//        guard let movableRange = indicesOfMovableElementsInOrder(targets) else { return nil }
//        let movables = self[movableRange].map { $0 as! Self.Generator.Element }
//        guard let i = correspondingIndex(targets.startIndex..<targets.endIndex, forIndexInSelf: movableRange.startIndex) else { return nil }
//        guard let j = correspondingIndex(targets.startIndex..<targets.endIndex, forIndexInSelf: movableRange.endIndex) else { return nil }
//        return (movables.maxDeltas(targets[i..<j].map { $0 }).minElement({ $0 < $1 }), movableRange)
//    }
//    @warn_unused_result func update(range: Range<Self.Index>, withDelta: Self.Generator.Element) -> [Self.Generator.Element]? {
//        guard range.startIndex >= startIndex && range.endIndex <= endIndex && range.startIndex < range.endIndex else {
//            return nil
//        }
//        var updated: [Self.Generator.Element] = []
//        for i in startIndex..<endIndex {
//            updated.append(range.contains(i) ? self[i] + withDelta : self[i])
//        }
//        return updated
//    }
//    @warn_unused_result func deltasOfEachMoveToReachTargets(targets: [Self.Generator.Element], existingDeltas: [Self.Generator.Element] = []) -> [Self.Generator.Element]? {
//        guard okToProceed(targets.count) else { return nil }
//        guard let dNow = maxDeltaNow(targets) else { return existingDeltas }
//        guard let d = dNow.delta else { return existingDeltas }
//        if d == d.zero { return existingDeltas }
//        guard let new = update(dNow.range, withDelta: d) else { return existingDeltas }
//        return new.deltasOfEachMoveToReachTargets(targets, existingDeltas: existingDeltas + [d])
//    }
//}
//
//extension Array {
//    func interwine(withArray: Array) -> Array {
//        var result: Array = []
//        for i in 0..<max(count, withArray.count) {
//            if i < count { result.append(self[i]) }
//            if i < withArray.count { result.append(withArray[i]) }
//        }
//        return result
//    }
//}
//
//
//
//typealias XsNow = [CGFloat]
//
//typealias DeltaXsForAllLinesInSingleMove = [CGFloat]
//
//typealias DeltaXs = [DeltaXsForAllLinesInSingleMove]





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