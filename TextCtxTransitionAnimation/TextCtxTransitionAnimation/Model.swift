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

protocol HasNumber {
    associatedtype number: Numberable
}

protocol ElementDeltable : HasNumber {
    var deltas: [number] { get }
}

protocol IndexOfRange {
    associatedtype rangeElement : ForwardIndexType
}

protocol MaxDeltaFoundable : HasNumber, IndexOfRange {
    @warn_unused_result func maxDelta(for range: Range<rangeElement>) -> number
}

extension Range : Hashable {
    public var hashValue: Int {
        return String(startIndex).hashValue ^ String(endIndex).hashValue
    }
}

protocol NewNumbersTransformable : HasNumber, IndexOfRange {
    @warn_unused_result func deltasWithRangesToAllNewNumbers(deltaPicker: (rangesAndDeltasForOneStep: [Range<rangeElement>: number]) -> (Range<rangeElement>, number)) -> [(Range<rangeElement>, number)]
    
}