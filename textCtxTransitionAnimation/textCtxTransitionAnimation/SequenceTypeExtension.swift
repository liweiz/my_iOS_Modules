//
//  SequenceTypeExtension.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-02-22.
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
    func combineContinuousRanges(startLocation: Int) -> NSRange {
        if underestimateCount() > 0 {
            var l = 0
            for range in self {
                l = l + range.length
            }
            return NSMakeRange(startLocation, l)
        }
        return NSMakeRange(0, 0)
    }
}