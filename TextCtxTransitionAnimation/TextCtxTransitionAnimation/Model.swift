//
//  Model.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-05-20.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

/*
 Problem to solve:
 Given a list of numbers and new values of each number. Each time only one
 delta can be applied to a sublist of numbers. The delta can not be larger than 
 the difference between current value and the new value for any number in the
 sublist. Find out each step's delta and sublist.
 */

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

protocol  {
    <#requirements#>
}