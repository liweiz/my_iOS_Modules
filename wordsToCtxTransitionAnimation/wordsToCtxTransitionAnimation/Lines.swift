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

func createLines(textView: UITextView) -> Lines {
    var mainLines = [MovableOneTextLineView]()
    var extraLines = [MovableOneTextLineView]()
    
}

struct Lines {
    var main: [MovableOneTextLineView]
    var extra: [MovableOneTextLineView]
    
    func sync(withLine: MovableOneTextLineView, deltaX: CGFloat) {
        let _linesToSync = linesToSync(withLine)
        if _linesToSync.count > 0 {
            let _baseXs = baseXs(_linesToSync)
            updateContentOffsets(_linesToSync, newXs: _baseXs.map { $0 + deltaX })
        }
    }
    
    func baseXs(lines: [MovableOneTextLineView]) -> [CGFloat] {
        return lines.map { return $0.contentOffset.x }
    }
    
    func linesToSync(afterLine: MovableOneTextLineView) -> [MovableOneTextLineView] {
        if let r = findElements(afterLine, inArray: main) {
            return r + findElements(main.indexOf(afterLine)!, inArray: extra)!
        } else {
            return findElements(afterLine, inArray: extra)! + findElements(extra.indexOf(afterLine)!, inArray: main)!
        }
        return [MovableOneTextLineView]()
    }
}


// Convert in root view's coordinates.
func textRectOriginInRoot(rootView: UIView, view: UITextView) -> CGPoint {
    return rootView.convertPoint(CGPointMake(view.bounds.origin.x + view.layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.x + view.textContainerInset.left, view.bounds.origin.y + view.layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.y + view.textContainerInset.top), fromView: view)
}

func distancesToMove(from: CGPoint, to: CGPoint) -> CGPoint {
    return CGPointMake(to.x - from.x, to.y - from.y)
}

func textViewOriginInRoot(view: UITextView, textOriginInRoot: CGPoint) -> CGPoint {
    return CGPointMake(textOriginInRoot.x - (view.bounds.origin.x + view.layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.x + view.textContainerInset.left), textOriginInRoot.y - (view.bounds.origin.y + view.layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin.y + view.textContainerInset.top))
}

// glyphOriginMatchingPoint is in superView's coordinates.

func getTextViewOrigin(view: UITextView, glyphOriginMatchingPoint: CGPoint) -> CGPoint {
    let b = view.bounds.origin
    let g = view.layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin
    let i = view.textContainerInset
    let p = view.convertPoint(glyphOriginMatchingPoint, fromView: view.superview)
    return CGPointMake(p.x - b.x - g.x - i.left, p.y - b.y - g.y - i.top)
}

// FirstGlyphOrigin in it's textView's coordinates.
func textViewFirstGlyphOrigin(view: UITextView) -> CGPoint {
    let b = view.bounds.origin
    let g = view.layoutManager.lineFragmentRectForGlyphAtIndex(0, effectiveRange: nil).origin
    let i = view.textContainerInset
    return CGPointMake(b.x + g.x + i.left, b.y + g.y + i.top)
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
