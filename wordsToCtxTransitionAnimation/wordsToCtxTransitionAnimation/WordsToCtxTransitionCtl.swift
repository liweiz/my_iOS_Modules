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
        ctxView.alpha = 0
        view.addSubview(ctxView)
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
    var firstWordsGlyphOrigin: CGPoint {
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
    func firstLineOrigin() -> CGPoint {
        
    }
    func generateLines() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// glyphOriginMatchingPoint is in superView's coordinates.
func textViewOrigin(view: UITextView, glyphOriginMatchingPoint: CGPoint) -> CGPoint {
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

// SyncCtl(a set of functions) to control the movement of MovableOneTextLineViews


func findTextLines(forBaseContentOffsetXs: [CGFloat], inCtxLines: [MovableOneTextLineView]) -> [MovableOneTextLineView] {
    return inCtxLines.filter { inCtxLines.indexOf($0) > inCtxLines.count - forBaseContentOffsetXs.count - 1 }
}






