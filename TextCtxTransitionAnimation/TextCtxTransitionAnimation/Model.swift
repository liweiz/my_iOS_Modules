//
//  Model.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-05-20.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation


//  Problem to solve:
//  Given a list of numbers and new values of each number. Each time, only one
//  non zero delta can be applied to a non empty subset of continuous members of
//  the list. The delta needs to minimize the gap between current value and new
//  value for each number applied, while not creating new gap for any member.

protocol Numberable: Comparable {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    func %(lhs: Self, rhs: Self) -> Self
    var zero: Self { get }
}

extension Numberable {
    var zero: Self {
        return self - self
    }
}

extension Double: Numberable {}
extension Float: Numberable {}
extension Int: Numberable {}
extension Int8: Numberable {}
extension Int16: Numberable {}
extension Int32: Numberable {}
extension Int64: Numberable {}
extension UInt: Numberable {}
extension UInt8: Numberable {}
extension UInt16: Numberable {}
extension UInt32: Numberable {}
extension UInt64: Numberable {}

protocol ElementOfSequenceTypesAtSamePositionGroupable {
    associatedtype Sequence: CollectionType
    associatedtype SequenceElement
    @warn_unused_result func groupable(sequences: [Sequence]) -> Bool
    @warn_unused_result func groupSequences(sequences: [Sequence], at position: Sequence.Index) -> [SequenceElement]?
    @warn_unused_result func groupSequences(sequences: [Sequence]) -> [[SequenceElement]]?
}