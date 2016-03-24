//
//  NSRangeHelper.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-03-21.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

extension SequenceType where Self.Generator.Element == NSRange {
    /// rangesIntersect returns the NSRanges in self's sequence that are intersected with a given NSRange.
    func rangesIntersect(range: NSRange) -> [NSRange] {
        return filter { NSIntersectionRange($0, range).length > 0 }
    }
    /// combineContinuousRanges returns the combined continuous NSRange. It returns nil is isComposedOfContinuousRanges == false.
    func combineContinuousRanges() -> NSRange? {
        if !isComposedOfContinuousRanges { return nil }
        return NSRange(
            location: (map { $0.location }).minElement()!,
            length: (map { $0.length }).reduce(0, combine: { $0 + $1 }))
    }
    /// isComposedOfContinuousRanges finds out if the sequence is composed of continuous NSRanges on by one. If the sequence is empty, it also indicates it's not.
    var isComposedOfContinuousRanges: Bool {
        if underestimateCount() == 0 { return false }
        let ints = (map { [$0.location, $0.length] }).flatten()
        var collector = [Int]()
        var collectors = [[Int]]()
        var index = 0
        for i in ints {
            collector.append(i)
            if index % 3 == 0 && index > 0 {
                collectors.append(collector)
                collector = Array(collector.dropFirst(2))
            }
            index += 1
        }
        let differences = collectors.map { $0[2] - $0[0] - $0[1] }
        return differences.reduce(0, combine: { $0 + $1 }) == 0 ? true : false
    }
}

