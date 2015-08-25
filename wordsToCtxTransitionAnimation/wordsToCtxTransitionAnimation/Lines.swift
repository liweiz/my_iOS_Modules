//
//  Lines.swift
//  wordsToCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2015-08-20.
//  Copyright © 2015 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

func updateContentOffsets(lines: [MovableOneTextLineView], newXs: [CGFloat]) {
    lines.forEach { $0.contentOffset = CGPointMake(newXs[lines.indexOf($0)!], $0.contentOffset.y) }
}

struct Lines {
    var main: [MovableOneTextLineView]
    var extra: [MovableOneTextLineView]
    
    func sync(line: MovableOneTextLineView, deltaX: CGFloat) {
        let linesToSync = findLinesToSync(line)
        if linesToSync.count > 0 {
            let baseXs = getBaseXs(linesToSync)
            updateContentOffsets(linesToSync, newXs: baseXs.map { $0 + deltaX })
        }
    }
    
    func getBaseXs(lines: [MovableOneTextLineView]) -> [CGFloat] {
        return lines.map { return $0.contentOffset.x }
    }
    
    func findLinesToSync(afterLine: MovableOneTextLineView) -> [MovableOneTextLineView] {
        if let r = findElements(afterLine, inArray: main) {
            return r + findElements(main.indexOf(afterLine)!, inArray: extra)!
        } else {
            return findElements(afterLine, inArray: extra)! + findElements(extra.indexOf(afterLine)!, inArray: main)!
        }
        return [MovableOneTextLineView]()
    }
}

func findElements<T: Equatable>(beyondElement: T, inArray: [T]) -> [T]? {
    if let i = inArray.indexOf(beyondElement) {
        return inArray.filter { inArray.indexOf($0) > i }
    }
    return nil
}

func findElements<T: Equatable>(beyondIndex: Int, inArray: [T]) -> [T]? {
    return inArray.count > beyondIndex ? inArray.filter { inArray.indexOf($0) > beyondIndex } : nil
}
