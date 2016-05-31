//
//  Model.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-05-20.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation


///  Problem to solve:
///  Given a list of numbers and new values of each number. Each time, only one
///  non zero delta can be applied to a non empty subset of continuous members
///  of the list. The delta needs to minimize the gap between current value and
///  new value for each number applied, while not creating new gap for any 
///  member.

typealias currentAndTargetNumbers = [[Numberable]]

/// Provides a Numberable type for adopters.
protocol HasNumber {
    associatedtype number: Numberable
}

/// Provides a ForwardIndexType type for adopters.
protocol IndexOfRange {
    associatedtype rangeElement : ForwardIndexType
}

protocol MaxDeltaFoundable : HasNumber, IndexOfRange {
    /// Returns the max delta that everyone in a range can be applied to.
    @warn_unused_result func maxDelta(for range: Range<rangeElement>) -> number
}

/// Makes Range conform to Hashable.
extension Range : Hashable {
    public var hashValue: Int {
        return String(startIndex).hashValue ^ String(endIndex).hashValue
    }
}

protocol NewNumbersTransformable : HasNumber, IndexOfRange {
    /// Returns range associated with delta for each step in the execution
    /// order. The deltaPicker provides how each delta is selected, given all
    /// possible deltas and their corresponding ranges for a step.
    @warn_unused_result func deltasWithRangesToAllNewNumbers(deltaPicker: (rangesAndDeltasForOneStep: [Range<rangeElement>: number]) -> (Range<rangeElement>, number)) -> [(Range<rangeElement>, number)]
}

protocol NumberableKeyNumberableArrayValueDictionary : CollectionType, DictionaryLiteralConvertible {
    associatedtype Value : Numberable
    associatedtype Element = (Key, Value)
    var keys: LazyMapCollection<[Value : Value], Value> { get }
    subscript (key: Value) -> Array<Value>? { get }
}

extension CollectionType where Generator.Element : NumberableKeyNumberableArrayValueDictionary {
    @warn_unused_result
    func maxDelta(for range: Range<Index>) -> Generator.Element.Key {
        let deltas = self[range].map { $0.Key - $0.Key }
    }

}
