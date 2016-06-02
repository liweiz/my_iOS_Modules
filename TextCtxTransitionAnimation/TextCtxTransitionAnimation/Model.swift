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

protocol DeltasFoundable : HasNumber, IndexOfRange {
    @warn_unused_result func deltas(for range: Range<rangeElement>) -> [number]
    /// Returns the max delta that everyone in a range can be applied to.
    @warn_unused_result func maxDelta(for range: Range<rangeElement>) -> number?
    @warn_unused_result func nonZeroMaxDeltaRangesAndDeltas() -> [Range<rangeElement>: number]
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
    @warn_unused_result func deltasWithRangesToAllNewNumbers(deltaPicker: (rangesAndDeltasForCurrentStep: [Range<rangeElement>: number]) -> (Range<rangeElement>, number)) -> [(Range<rangeElement>, number)]
}

protocol NumberableKeyNumberableArrayValueDictionary : CollectionType, DictionaryLiteralConvertible {
    associatedtype MetaType : Numberable
    associatedtype Element = (MetaType, MetaType)
    var keys: LazyMapCollection<[MetaType : MetaType], MetaType> { get }
    subscript (key: MetaType) -> Array<MetaType>? { get }
}

extension CollectionType where Generator.Element : NumberableKeyNumberableArrayValueDictionary, SubSequence.Generator.Element == Generator.Element {
    @warn_unused_result
    func deltas(for range: Range<Index>) -> [Generator.Element.MetaType] {
        let membersInRange = self[range]
        return membersInRange.map { (dic) -> Generator.Element.MetaType in
            guard let key = dic.keys.first else {
                fatalError("No Key in Dictionary<NumberableKeyNumberableArrayValueDictionary, NumberableKeyNumberableArrayValueDictionary>")
            }
            guard let latest = dic[key]?.last else {
                fatalError("No member in Array Value of Dictionary<NumberableKeyNumberableArrayValueDictionary, NumberableKeyNumberableArrayValueDictionary>")
            }
            return key - latest
        }
    }
    
    /// Returns the max delta value 'Self.Generator.Element.MetaType' valid for
    /// all members in the 'range'; returns 'nil', if no member in 'range'.
    @warn_unused_result
    func maxDelta(for range: Range<Index>) -> Generator.Element.MetaType? {
        return deltas(for: range).minElement()
    }
    @warn_unused_result
    func nonZeroMaxDeltaRangesAndDeltas() -> [Range<Index>: Generator.Element.MetaType] {
        let ds = deltas(for: startIndex..<endIndex)
        var result: [Range<Index>: Generator.Element.MetaType] = [:]
        var startI: Index? = nil
        var endI: Index? = nil
        var deltasGen = ds.generate()
        for i in startIndex..<endIndex {
            guard let delta = deltasGen.next() else {
                fatalError("func nonZeroMaxDeltaRangesAndDeltas came up with invalid deltas.")
            }
            if delta != delta.zero {
                guard let s = startI else { startI = i }
                endI = i
            }
            
        }
        
    }
    
    @warn_unused_result
    func deltasWithRangesToAllNewNumbers(deltaPicker: (rangesAndDeltasForCurrentStep: [Range<Index>: Generator.Element.MetaType]) -> (Range<Index>, Generator.Element.MetaType)) -> [(Range<Index>, Generator.Element.MetaType)] {
        
    }
}
