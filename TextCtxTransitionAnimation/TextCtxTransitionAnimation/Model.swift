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

/// Group every same position elements of the nested sequences to new sequence.
/// Shortest nested sequence sets the length of the new sequence.
/// Example: [[1, 2, 3], [4, 5, 6], [7, 8]] => [[1, 4, 7], [2, 5, 8]]
extension SequenceType where Generator.Element : SequenceType {
    /// Returns Generators of nested sequences.
    @warn_unused_result
    func generatorsOfElements() -> [Generator.Element.Generator] {
        return map { $0.generate() }
    }
    
    /// Returns all elements from next() by given Generators.
    /// Returns nil, if any next() is nil.
    @warn_unused_result
    func nextElements(from generators: [Generator.Element.Generator]) -> ([Generator.Element.Generator.Element], [Generator.Element.Generator])? {
        var elements: [Generator.Element.Generator.Element] = []
        var newGenerators: [Generator.Element.Generator] = []
        for gen in generators {
            var newGen = gen
            guard let nextElement = newGen.next() else { return nil }
            elements.append(nextElement)
            newGenerators.append(newGen)
        }
        return (elements, newGenerators)
    }
    
    /// Returns new nested array with each element is an array of same position
    /// elements.
    /// Shortest nested sequence sets the length of the new array.
    var eachElementToSamePositionElements: [[Generator.Element.Generator.Element]] {
        var generators = generatorsOfElements()
        var newSequence: [[Generator.Element.Generator.Element]] = []
        while let result = nextElements(from: generators) {
            generators = result.1
            newSequence.append(result.0)
        }
        return newSequence
    }
}