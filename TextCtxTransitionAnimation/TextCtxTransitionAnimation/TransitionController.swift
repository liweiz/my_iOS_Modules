//
//  TransitionController.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-04-07.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

class TransitionController: UIViewController {
    var textView: UITextView?
    var ctxView: UITextView?
    var width: CGFloat?
    var deltasFromTextToCtxEachLine = [CGPoint]()
    init(textView: UITextView, ctxView: UITextView, width: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.textView = textView
        self.ctxView = ctxView
        self.width = width
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        let size = UIApplication.sharedApplication().keyWindow?.rootViewController?.view.frame.size
        view = UIView(frame: CGRectMake((size!.width - width!) / 2, 0, width!, size!.height))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var linesForText = textLines(textView!)
        let linesForCtx = ctxLines(ctxView!, textInCtx: textView!.text)
        if linesForText.count * linesForCtx.count > 0 {
            linesForText.forEach {
                $0.frame.origin = view.convertPoint($0.frame.origin, fromView: textView!)
                $0.removeFromSuperview()
                view.addSubview($0)
            }
            linesForCtx.forEach {
                $0.frame.origin = view.convertPoint($0.frame.origin, fromView: ctxView!)
                $0.removeFromSuperview()
                view.addSubview($0)
            }
            var i = 0
            for textLine in linesForText {
                deltasFromTextToCtxEachLine.append(textLine.frame.origin.deltaTo(linesForCtx[i].frame.origin))
                i += 1
            }
            if linesForCtx.count > linesForText.count && linesForCtx.count > 1 {
                let gap = linesForCtx[1].frame.origin.y - linesForCtx[0].frame.maxY
                let extraTextLine = extraLineForText(linesForText.last!, textRange: (ctxView!.text as NSString).rangeOfString(textView!.text), verticalLineFragmentGap: gap)
                linesForText.append(extraTextLine)
                deltasFromTextToCtxEachLine.append(extraTextLine.frame.origin.deltaTo(linesForCtx.last!.frame.origin))
            }
        }
    }
}

func pushNextLine

func extraLineForText(lastLineForText: SingleLineTextView, textRange: NSRange, verticalLineFragmentGap: CGFloat) -> SingleLineTextView {
    let y = lastLineForText.frame.maxY + verticalLineFragmentGap
    var x: CGFloat = 0
    if textRange.location + textRange.length == (lastLineForText.text as NSString).length {
        x = lastLineForText.frame.origin.x - lastLineForText.frame.size.width
    } else {
        var xSet = false
        for nextLocation in (textRange.location + textRange.length)...((lastLineForText.text as NSString).length - 1) {
            if (lastLineForText.text as NSString).substringWithRange(NSMakeRange(nextLocation, 1)) != " " {
                let internalOrigin = lastLineForText.convertFromTextContainerCoordinatesToSelf(lastLineForText.rectOriginForCharRangeInTextContainerCoordinates(NSMakeRange(nextLocation, 1)))
                x = lastLineForText.frame.origin.x - internalOrigin.x
                xSet = true
            }
        }
        if !xSet {
            x = lastLineForText.frame.origin.x - lastLineForText.frame.size.width
        }
    }
    let extraLine = SingleLineTextView(attriText: lastLineForText.attributedText, lineHeight: lastLineForText.frame.size.height)
    extraLine.frame.origin = CGPointMake(x, y)
    lastLineForText.superview!.addSubview(extraLine)
    return extraLine
}

func textLines(textView: UITextView) -> [SingleLineTextView] {
    return textView.singleLineTextViews()
}

func ctxLines(ctxView: UITextView, textInCtx: String) -> [SingleLineTextView] {
    var lines = [SingleLineTextView]()
    let range = (ctxView.text as NSString).rangeOfString(textInCtx)
    if range.location == NSNotFound { return lines }
    var lineIndices = [Int]()
    var i = 0
    for charRange in ctxView.charRangesForEachLine! {
        if NSIntersectionRange(charRange, range).length > 0 {
            lineIndices.append(i)
        }
        i += 1
    }
    let views = ctxView.singleLineTextViews()
    for index in lineIndices {
        lines.append(views[index])
    }
    return lines
}

