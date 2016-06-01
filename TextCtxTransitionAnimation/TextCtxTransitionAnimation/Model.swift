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
    @warn_unused_result func maxDelta(for range: Range<rangeElement>) -> number?
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
    associatedtype MetaType : Numberable
    associatedtype Element = (MetaType, MetaType)
    var keys: LazyMapCollection<[MetaType : MetaType], MetaType> { get }
    subscript (key: MetaType) -> Array<MetaType>? { get }
}



extension CollectionType where Generator.Element : NumberableKeyNumberableArrayValueDictionary, SubSequence.Generator.Element == Generator.Element {
    /// Returns the max delta value 'Self.Generator.Element.MetaType' valid for 
    /// all members in the 'range'; returns 'nil', if no member in 'range'.
    @warn_unused_result
    func maxDelta(for range: Range<Index>) -> Generator.Element.MetaType? {
        let membersInRange = self[range]
        let deltas = membersInRange.map { (dic) -> Generator.Element.MetaType in
            guard let key = dic.keys.first else {
                fatalError("No Key in Dictionary<NumberableKeyNumberableArrayValueDictionary, NumberableKeyNumberableArrayValueDictionary>")
            }
            guard let latest = dic[key]?.last else {
                fatalError("No member in Array Value of Dictionary<NumberableKeyNumberableArrayValueDictionary, NumberableKeyNumberableArrayValueDictionary>")
            }
            return key - latest
        }
        return deltas.minElement()
    }
}
