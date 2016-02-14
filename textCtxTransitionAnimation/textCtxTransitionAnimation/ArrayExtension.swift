//
//  ArrayExtension.swift
//  textCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-02-13.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    func pickEvenOrOdd(pickEven: Bool) -> [Element] {
        var r = [Element]()
        var i = 0
        for t in self {
            if i % 2 == 1 {
                r.append(t)
            }
            i += 1
        }
        return r
    }
}

extension Array where Element: Equatable {
    func findElements(beyondElement: Element) -> [Element]? {
        if let i = indexOf(beyondElement) {
            return filter { indexOf($0) > i }
        }
        return nil
    }
    func findElements(beyondIndex: Int) -> [Element]? {
        return count > beyondIndex ? filter { indexOf($0) > beyondIndex } : nil
    }
}

extension Array where Element: Line {
//    let visiableCharacterRanges: [NSRange]
    var EvenIndexedElements: [Line] {
        return pickEvenOrOdd(true)
    }
    var OddIndexedElements: [Line] {
        return pickEvenOrOdd(false)
    }
    var BaseXs: [CGFloat] {
        return map { return $0.contentOffset.x }
    }
    func scrollAlongX(deltaX: CGFloat, animated: Bool) {
        for l in self {
            l.setContentOffset(CGPointMake(l.contentOffset.x + deltaX, l.contentOffset.y), animated: animated)
        }
    }
}

