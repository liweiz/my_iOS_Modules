//
//  NSRangeHelper.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-03-21.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

extension SequenceType where Self.Generator.Element == NSRange {
    func rangeIntersected(range: NSRange) -> (NSRange) -> NSRange {
        return {(r: NSRange) -> NSRange in
            return NSIntersectionRange(r, range)
        }
    }
    func rangesIntersect(range: NSRange) -> [NSRange] {
        let x = rangeIntersected(range)
        return filter { x($0).length > 0 }
    }
    func combineContinuousRanges() -> NSRange? {
        if !isComposedOfContinuousRanges { return nil }
        return NSRange()
    }
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