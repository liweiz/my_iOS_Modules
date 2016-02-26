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
    var visiableCharacterRanges: [NSRange] {
        return map { return $0.visiableCharacterRange }
    }
    var evenIndexedElements: [Element] {
        return pickEvenOrOdd(true)
    }
    var oddIndexedElements: [Element] {
        return pickEvenOrOdd(false)
    }
    var baseXs: [CGFloat] {
        return map { return $0.contentOffset.x }
    }
    func scrollLeadingLineWithRestFollowAlongX(newX: CGFloat, animated: Bool, firstIsLeading: Bool) -> CGFloat {
        let leadingLine = firstIsLeading ? first! : last!
        let deltaX = leadingLine.scrollToAnotherState(CGPointMake(newX, first!.contentOffset.y), animated: animated)
        filter { indexOf($0) > 0 }.scrollAllAlongX(deltaX, animated: animated)
        return deltaX
    }
    func scrollAllAlongX(deltaX: CGFloat, animated: Bool) {
        forEach { $0.setContentOffset(CGPointMake($0.contentOffset.x + deltaX, $0.contentOffset.y), animated: animated) }
    }
    func rectOriginsForCharacterRanges(ranges: [NSRange]) -> [CGPoint] {
        return map { $0.textView.layoutManager.boundingRectForGlyphRange($0.textView.layoutManager.glyphRangeForCharacterRange(ranges[indexOf($0)!], actualCharacterRange: nil), inTextContainer: $0.textView.textContainer).origin }
    }
    func evenIndexedLinesLessThan(number: Int) -> [Line] {
        return filter { indexOf($0)! < number && indexOf($0)! % 2 == 0 }
    }
    func transitToText(animated: Bool) {
        
    }
}