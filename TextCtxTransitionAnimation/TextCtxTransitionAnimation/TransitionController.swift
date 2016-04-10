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
    var linesForText: [SingleLineTextView]?
    var linesForTextExtra: [SingleLineTextView]?
    var filteredCharRangesForLinesInCtx: [NSRange]?
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
        linesForText = textLines(textView!)
        let filteredLinesAndCharRangesForCtx = filteredCtxLinesAndCharRange(ctxView!, textInCtx: textView!.text)
        let filteredLinesForCtx = filteredLinesAndCharRangesForCtx.lines
        filteredCharRangesForLinesInCtx = filteredLinesAndCharRangesForCtx.charRanges
        if linesForText!.count * filteredLinesForCtx.count > 0 {
            linesForText!.forEach {
                $0.frame.origin = view.convertPoint($0.frame.origin, fromView: textView!)
                $0.removeFromSuperview()
                view.addSubview($0)
            }
            filteredLinesForCtx.forEach {
                $0.frame.origin = view.convertPoint($0.frame.origin, fromView: ctxView!)
                $0.removeFromSuperview()
                view.addSubview($0)
            }
            var i = 0
            for textLine in linesForText! {
                deltasFromTextToCtxEachLine.append(textLine.frame.origin.deltaTo(filteredLinesForCtx[i].frame.origin))
                i += 1
            }
            if filteredLinesForCtx.count > linesForText!.count && filteredLinesForCtx.count > 1 {
                let gap = filteredLinesForCtx[1].frame.origin.y - filteredLinesForCtx[0].frame.maxY
                let extraTextLine = extraLineForText(linesForText!.last!, textRange: (ctxView!.text as NSString).rangeOfString(textView!.text), verticalLineFragmentGap: gap)
                linesForText!.append(extraTextLine)
                deltasFromTextToCtxEachLine.append(extraTextLine.frame.origin.deltaTo(filteredLinesForCtx.last!.frame.origin))
            }
            linesForTextExtra = linesForText
            let clearCharRanges = clearContentCharRanges(filteredCharRangesForLinesInCtx!, textCharLength: (ctxView!.text! as NSString).length)
            linesForText!.makeContentsClear(clearCharRanges.main)
            linesForTextExtra!.makeContentsClear(clearCharRanges.extra)
            
        }
    }
    func setFollowers(main: [SingleLineTextView], extra: [SingleLineTextView]) {
        
    }
    func clearContentCharRanges(lineCharRangesForText: [NSRange], textCharLength: Int) -> (main: [NSRange], extra: [NSRange]) {
        return (lineCharRangesForText.map { NSMakeRange($0.location + $0.length, textCharLength - ($0.location + $0.length)) }, lineCharRangesForText.map { NSMakeRange(0, $0.location + $0.length) })
    }
    func nextLineIsSynced(currentLine: SingleLineTextView, nextLine: SingleLineTextView) -> Bool {
        return currentLine.frame.origin.x - nextLine.frame.origin.x == view.frame.width
    }
//    func makeNextLineSynced(currentLine: SingleLineTextView, nextLine: SingleLineTextView) {
//        let horizontalDelta = currentLine.frame.origin.x - nextLine.frame.origin.x - view.bounds.width
//        
//    }
//    func checkVisiableRightEdgePosition(toLineWithRange: SingleLineTextView, nextStep: [()]) {
//        if let position = visiableRightEdgePosition(toLineWithRange) {
//            if nextStep.count == 5 {
//                switch position {
//                case .Right:
//                    // Do nothing
//                    nextStep[0]
//                case .RightEdge:
//                    // Check if next line is synced.
//                    nextStep[1]
//                case .Inside:
//                    // Sync next line
//                    nextStep[2]
//                case .LeftEdge:
//                    // Check if next line is synced.
//                    nextStep[3]
//                case .Left:
//                    // Do nothing
//                    nextStep[4]
//            }
//        }
//    }
    func visiableRightEdgePosition(toLineWithRange: SingleLineTextView) -> HorizontalPositionToRange? {
        if let rect = toLineWithRange.lineTailingBlankSpaceRectInSelf {
            visiableRightEdgePositionToRange(rect.minX, positionRight: rect.maxX)
        }
        return nil
    }
    func visiableRightEdgePositionToRange(positionLeft: CGFloat, positionRight: CGFloat) -> HorizontalPositionToRange {
        return horizontalPositionToRange(view.bounds.maxX, positionLeft: positionLeft, positionRight: positionRight)
    }
    
    func deltaToVisiableRightEdge(fromPoint: CGPoint, lineWithPoint: SingleLineTextView) -> CGFloat? {
        let pointFromLine = view.convertPoint(fromPoint, fromView: lineWithPoint)
        return view.bounds.maxX - pointFromLine.x
    }
    
    
}




enum HorizontalPositionToRange {
    case Left
    case LeftEdge
    case Inside
    case RightEdge
    case Right
}

func horizontalPositionToRange(positionToFind: CGFloat, positionLeft: CGFloat, positionRight: CGFloat) -> HorizontalPositionToRange {
    let deltaToRight = positionRight - positionToFind
    let deltaToLeft = positionToFind - positionLeft
    if deltaToLeft < 0 { return .Left }
    if deltaToLeft == 0 { return .LeftEdge }
    if deltaToRight > 0 { return .Right }
    if deltaToRight == 0 { return .RightEdge }
    return .Inside
}


// Because all tailing blank-spaces belong to the upper line, the lower line moves out the blank-spaces to sync with the content shown in upper line, while the upper line stops and waiting for complete of the sync.


func tailingBlankSpaceCharRange(inText: String, inRange: NSRange) -> NSRange? {
    let text = inText as NSString
    let nextLocation = inRange.location + inRange.length
    if nextLocation > text.length { return nil }
    for i in 1...inRange.length {
        let prevousLocation = nextLocation - i
        if text.substringWithRange(NSMakeRange(prevousLocation, 1)) != " " {
            return NSMakeRange(prevousLocation + 1, i - 1)
        }
    }
    return inRange
}

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

func filteredCtxLinesAndCharRange(ctxView: UITextView, textInCtx: String) -> (lines: [SingleLineTextView], charRanges: [NSRange]) {
    var lines = [SingleLineTextView]()
    var ranges = [NSRange]()
    let range = (ctxView.text as NSString).rangeOfString(textInCtx)
    if range.location == NSNotFound { return (lines, ranges) }
    var lineIndices = [Int]()
    var i = 0
    for charRange in ctxView.charRangesForEachLine! {
        if NSIntersectionRange(charRange, range).length > 0 {
            lineIndices.append(i)
            ranges.append(charRange)
        }
        i += 1
    }
    let views = ctxView.singleLineTextViews()
    for index in lineIndices {
        lines.append(views[index])
    }
    return (lines, ranges)
}

