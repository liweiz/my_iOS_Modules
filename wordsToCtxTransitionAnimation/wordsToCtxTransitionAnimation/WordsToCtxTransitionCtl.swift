//
//  WordsToCtxTransitionCtl.swift
//  wordsToCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2015-08-10.
//  Copyright © 2015 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

let screenSize = UIScreen.mainScreen().bounds.size

// WordsView(UITextView) to provide info of start state

// SampleView(UITextView) to mock the end state
func getSampleCtxView(firstGlyphOrigin: CGPoint, words: NSAttributedString, ctx: NSString, containerSize: CGSize = screenSize) -> UITextView {
    
}
// Adjuster(UIScrollView) to transit between words and context
func getAdjuster() -> UIScrollView {
    
}
// MovableOneTextLineView(UIScrollView + UITextView) to compose the animatedContext
func getMovableOneTextLineView(origin: CGPoint, visiableGlyphRange: NSRange, ctx: NSAttributedString) -> MovableOneTextLineView {
    
}



// CtxLinesCtl(a set of functions) to have the lastest info about MovableOneTextLineViews for a certain context and refresh them

func getLinesInfoInWordsView(wordsView: UITextView) -> (glyphRanges: [NSRange], lineRects: [CGRect]) {
    
}

func getLines(glyphRanges: [NSRange], lineRects: [CGRect]) -> [MovableOneTextLineView] {
    
}

// To add wordsToCtx transition, we need: 1) view to attach on 2) viewController to attach on 3) words' textView 4) origin in viewToAttachOn's coordinates 5) ctx's texts
class WordsToCtxTransitionCtl: UIViewController, UIScrollViewDelegate {
    init(ctxOriginInWordsView c: CGPoint, ctxString s: NSString, wordsView w: UITextView, addToView v: UIView, wordsViewCtl vc: UIViewController? = nil) {
        super.init(nibName: nil, bundle: nil)
        ctxOrigin = c
        ctxString = s
        wordsView = w
        addToView = v
        wordsViewCtl = vc
        adjuster = getAdjuster(addToView.frame.size)
        
    }
    override func loadView() {
        view = UIView(frame: CGRectMake(0, 0, addToView.frame.width, addToView.frame.width))
        let p = view.convertPoint(ctxOrigin, fromView: wordsView)
        ctxView = UITextView(frame: CGRectMake(p.x, p.y, adjuster.frame.width - (p.x - adjuster.contentOffset.x) * 2, adjuster.frame.height - (p.x - adjuster.contentOffset.x)))
        ctxView.attributedText = attriCtx
        view.addSubview(ctxView)
        adjuster.addSubview(ctxView)
        view.addSubview(adjuster)
        
    }
    let ctxOrigin: CGPoint
    let ctxString: NSString
    let wordsView: UITextView
    let addToView: UIView
    let wordsViewCtl: UIViewController?
    var ctxColor: UIColor = UIColor.grayColor()
    var attriCtx: NSAttributedString {
        let attri = attriWords.attributesAtIndex(0, effectiveRange: nil)
        let s = NSMutableAttributedString(string: ctxString as String, attributes: attri)
        s.setValue(ctxColor, forKey: NSForegroundColorAttributeName)
        s.addAttribute(NSForegroundColorAttributeName, value: UIColor.clearColor(), range: (s.string as NSString).rangeOfString(attriWords.string))
        return s
    }
    var attriWords: NSAttributedString {
        return wordsView.attributedText
    }
    var firstGlyphOrigin: CGPoint {
        return view.convertPoint(getFisrtGlyphOrigin(wordsView), fromView: wordsView)
    }
    let adjuster: UIScrollView
    func getAdjuster(frameSize: CGSize) -> UIScrollView {
        let a = UIScrollView(frame: CGRectMake(0, 0, frameSize.width, frameSize.height))
        a.contentSize = CGSizeMake(a.frame.width * 3, a.frame.height * 3)
        a.contentOffset = CGPointMake(a.frame.width, a.frame.height)
        return a
    }
    var ctxView: UITextView
    
    var triggeringLineView: MovableOneTextLineView
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if scrollView.isEqual(triggeringLineView) {
            
        }
    }
    func expand() {
        
    }
    var glyphRangesInWordsView: [NSRange] {
        return
    }
    func generateLines() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// SyncCtl(a set of functions) to control the movement of MovableOneTextLineViews
struct Lines {
    var main: [MovableOneTextLineView]
    var extra: [MovableOneTextLineView]
    
    
    
    
    
    func sync(line: MovableOneTextLineView, deltaX: CGFloat) {
        let linesToSync = findLinesToSync(line)
        if linesToSync.count > 0 {
            let baseXs = getBaseXs(linesToSync)
            updateContentOffset(linesToSync, newXs: baseXs.map { $0 + deltaX })
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

func findTextLines(forBaseContentOffsetXs: [CGFloat], inCtxLines: [MovableOneTextLineView]) -> [MovableOneTextLineView] {
    return inCtxLines.filter { inCtxLines.indexOf($0) > inCtxLines.count - forBaseContentOffsetXs.count - 1 }
}

func updateContentOffset(lines: [MovableOneTextLineView], newXs: [CGFloat]) {
    lines.forEach { $0.contentOffset = CGPointMake(newXs[lines.indexOf($0)!], $0.contentOffset.y) }
}

func refreshMovableOneTextLineView(baseOffsetXs: [CGFloat], deltaOffsetX: CGFloat, lineViews: [MovableOneTextLineView]) {
    lineViews.forEach { $0.contentOffset = CGPointMake(baseOffsetXs[lineViews.indexOf($0)!] + deltaOffsetX, $0.contentOffset.y) }
}


class MovableOneTextLineView: UIScrollView, UIScrollViewDelegate {
    let textView: UITextView
    // Used by lineExtraView to hide the visiable part.
    var visiableCharacterRange: NSRange!
    var visiableGlyphRange: NSRange {
        return textView.layoutManager.glyphRangeForCharacterRange(visiableCharacterRange, actualCharacterRange: nil)
    }
    var visiableGlyphsRectX: CGFloat {
        return textView.frame.origin.x + textView.textContainer.lineFragmentPadding + textView.textContainerInset.left + textView.layoutManager.boundingRectForGlyphRange(visiableGlyphRange, inTextContainer: textView.textContainer).origin.x
    }
    init(textViewToInsert: UITextView, rect: CGRect) {
        super.init(frame: rect)
        decelerationRate = UIScrollViewDecelerationRateFast
        contentSize = CGSizeMake(textViewToInsert.frame.width * 3, textViewToInsert.frame.height)
        textView = textViewToInsert
        addSubview(textView)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func hideVisiablePart(animated: Bool) -> Bool {
        if visiableGlyphsRectX < contentOffset.x + frame.width {
            // Visiable part is still visiable.
            setContentOffset(CGPointMake(visiableGlyphsRectX - frame.width, contentOffset.y), animated: animated)
            return true
        }
        return false
    }
    
}