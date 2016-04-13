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
    var filteredLinesForCtx: [SingleLineTextView]?
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
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        linesForText = textLines(textView!, fullTextView: ctxView)
        
        let filteredLinesAndCharRangesForCtx = filteredCtxLinesAndCharRange(ctxView!, textInCtx: textView!.text)
        filteredLinesForCtx = filteredLinesAndCharRangesForCtx.lines
        filteredCharRangesForLinesInCtx = filteredLinesAndCharRangesForCtx.charRanges
        if linesForText!.count * filteredLinesForCtx!.count > 0 {
            linesForText!.forEach {
                $0.frame.origin = view.convertPoint($0.frame.origin, fromView: textView!)
                $0.removeFromSuperview()
                view.addSubview($0)
            }
            filteredLinesForCtx!.forEach {
                $0.frame.origin = view.convertPoint($0.frame.origin, fromView: ctxView!)
                $0.removeFromSuperview()
                view.addSubview($0)
            }
            var i = 0
            for textLine in linesForText! {
                deltasFromTextToCtxEachLine.append(textLine.frame.origin.deltaTo(filteredLinesForCtx![i].frame.origin))
                i += 1
            }
            if filteredLinesForCtx!.count > linesForText!.count && filteredLinesForCtx!.count > 1 {
                let gap = filteredLinesForCtx![1].frame.origin.y - filteredLinesForCtx![0].frame.maxY
                let extraTextLine = extraLineForText(linesForText!.last!, textRange: (ctxView!.text as NSString).rangeOfString(textView!.text), verticalLineFragmentGap: gap)
                linesForText!.append(extraTextLine)
                deltasFromTextToCtxEachLine.append(extraTextLine.frame.origin.deltaTo(filteredLinesForCtx!.last!.frame.origin))
            }
            linesForTextExtra = [SingleLineTextView]()
            for l in linesForText! {
                let lExtra = SingleLineTextView(attriText: l.attributedText, lineHeight: l.frame.size.height)
                lExtra.frame = l.frame
                view.addSubview(lExtra)
                linesForTextExtra?.append(lExtra)
            }
            let clearCharRangesInCtx = charRangesOfClearContent(filteredCharRangesForLinesInCtx!, textCharLength: (ctxView!.text! as NSString).length)
            
            let charRangeTextViewEachLineInCtx = (textView!.charRangesForEachLine!.map { (textView!.text as NSString).substringWithRange($0) }).map { (ctxView!.text as NSString).rangeOfString($0) }
            let clearCharRangesInText = charRangesOfClearContent(charRangeTextViewEachLineInCtx, textCharLength: (ctxView!.text! as NSString).length)
            linesForText!.makeContentsClear(clearCharRangesInCtx.tailing)
            linesForTextExtra!.makeContentsClear(clearCharRangesInCtx.heading)
            linesForTextExtra!.makeContentsClear(clearCharRangesInText.tailing)
            setTextToCtxFollowers(linesForText!, extra: linesForTextExtra!)
            filteredLinesForCtx!.forEach { $0.hidden = true }
            linesForTextExtra!.dropLast().forEach {
                if targetPoint($0)!.point.x == $0.frame.origin.x {
                    $0.makeContentClear(NSMakeRange(0, ($0.text! as NSString).length))
                }
            }
            linesForTextExtra!.last!.makeContentClear(NSMakeRange(0, (linesForTextExtra!.last!.text! as NSString).length))
        }
    }
    func setTextToCtxFollowers(main: [SingleLineTextView], extra: [SingleLineTextView]) {
        let c = main.count
        if c == extra.count {
            for i in 0..<c {
                main[i].follower = extra[i]
                if i != c - 1 {
                    extra[i].follower = main[i + 1]
                }
            }
        }
    }
    func charRangesOfClearContent(lineCharRangesForText: [NSRange], textCharLength: Int) -> (heading: [NSRange], tailing: [NSRange]) {
        var raw = (lineCharRangesForText.map { NSMakeRange(0, $0.location + $0.length) }, lineCharRangesForText.map { NSMakeRange($0.location + $0.length, textCharLength - ($0.location + $0.length)) })
        raw.0[raw.0.count - 1] = NSMakeRange(textCharLength - 1, 0)
        return raw
    }
    func deltaToSyncedPosition(ofNextLine: SingleLineTextView?, currentLine: SingleLineTextView) -> CGFloat? {
        if let next = ofNextLine {
            return currentLine.frame.origin.x - (next.frame.origin.x + view.frame.width)
        }
        return nil
    }
    func nextLine(currentLine: SingleLineTextView) -> SingleLineTextView? {
        if let index = linesForText?.indexOf(currentLine) {
            return index == linesForText!.count - 1 ? nil : linesForText![index + 1]
        } else if linesForTextExtra!.contains(currentLine) {
            return currentLine.follower as? SingleLineTextView
        }
        return nil
    }
    func index(forLine: SingleLineTextView) -> (isForExtra: Bool, index: Int)? {
        if let lines = linesForText {
            if let i = lines.indexOf(forLine) {
                return (false, i)
            }
            if let i = linesForTextExtra!.indexOf(forLine) {
                return (true , i)
            }
        }
        return nil
    }
    func targetPointRaw(forLine: SingleLineTextView) -> (isForExtra: Bool, point: CGPoint)? {
        if let i = index(forLine) {
            let correspondingLineOrigin = (filteredLinesForCtx!.map { $0.frame.origin })[i.index]
            if i.isForExtra {
                if i.index + 1 < linesForTextExtra?.count {
                    let x = (filteredLinesForCtx!.map { $0.frame.origin })[i.index + 1].x + view.bounds.width
                    return (i.isForExtra, CGPointMake(x, correspondingLineOrigin.y))
                }
            } else {
                return (i.isForExtra, correspondingLineOrigin)
            }
        }
        return nil
    }
    func targetPoint(forLine: SingleLineTextView) -> (isForExtra: Bool, point: CGPoint)? {
        let t = targetPointRaw(forLine)
        print("targetPointRaw: \(t)")
        if let targetRaw = t {
            if targetRaw.isForExtra {
                if let nextline = forLine.follower as? SingleLineTextView {
                    if let nextLineTargetRaw = targetPointRaw(nextline) {
                        if nextLineTargetRaw.point.x == nextline.frame.origin.x {
                            return (targetRaw.isForExtra, forLine.frame.origin)
                        }
                    }
                }
            }
        }
        return t
    }
    func startHorizontalAnimation() {
        animateHorizontally((linesForText?.first!)!)
        
    }
    
    func animateHorizontally(line: SingleLineTextView) {
        if let target = targetPoint(line) {
            let targetPosition = target.point.x
            let deltaMax = targetPosition - line.frame.origin.x
            if deltaMax == 0 {
                // Animation for SingleLineTextView all done, pass to next one.
                if let follower = line.follower {
                    animateHorizontally(follower as! SingleLineTextView)
                }
            } else {
                var delta: CGFloat = 0
                var lineToMove: SingleLineTextView
                if let next = nextLine(line) {
                    // Make sure following lines are synced before animation.
                    if let deepDeltaToSync = deepDeltaToSyncedPosition(next, currentLine: line) {
                        if deepDeltaToSync.delta > 0 {
                            // Sync with min distance.
                            delta = min(deltaMax, deepDeltaToSync.delta)
                            lineToMove = line
                        } else if deepDeltaToSync.delta == 0 {
                            // All lines below are synced.
                            delta = deltaMax
                            lineToMove = line
                        } else {
                            // Sync next line to match current line.
                            delta = deepDeltaToSync.delta
                            lineToMove = next
                        }
                        print("total line no: \(linesForText?.count); lineToMove index: main: \(linesForText?.indexOf(lineToMove)), extra: \(linesForTextExtra?.indexOf(lineToMove)); toLine index: main: \(linesForText?.indexOf(deepDeltaToSync.deepLine)), extra: \(linesForTextExtra?.indexOf(deepDeltaToSync.deepLine))")
                        lineToMove.animateHorizontally(lineToMove, toLine: deepDeltaToSync.deepLine, byDelta: delta, delegate: self)
                        return
                    } else {
                        delta = deltaMax
                        lineToMove = line
                        lineToMove.animateHorizontally(lineToMove, toLine: linesForText!.last!, byDelta: delta, delegate: self)
                        return
                    }
                }
                animateOneLineHorizontally(line, byDelta: deltaMax)
            }
        }
    }
    func animateOneLineHorizontally(line: SingleLineTextView, byDelta: CGFloat) {
        line.startHorizontalAnimation(byDelta, delegate: self)
        if line.follower!.frame.origin.y == line.frame.origin.y {
            (line.follower! as! SingleLineTextView).startHorizontalAnimation(byDelta, delegate: self)
        }
    }
    /// deepDeltaToSyncedPosition returns the delta to sync for closet line below. Nil is returned, if there is no more line below.
    func deepDeltaToSyncedPosition(withNextLine: SingleLineTextView?, currentLine: SingleLineTextView) -> (delta: CGFloat, deepLine: SingleLineTextView)? {
        if let next = withNextLine {
            // Make sure following lines are synced before animation.
            if let delta = deltaToSyncedPosition(next, currentLine: currentLine) {
                switch delta {
                case 0:
                    print("animation: synced, ready to move freely.")
                    return deepDeltaToSyncedPosition(nextLine(next), currentLine: next)
                case -abs(delta):
                    print("animation: not synced, sync with next line.")
                    return (abs(delta), currentLine)
                default:
                    print("animation: over synced, move next line to sync with current line.")
                    return (-delta, currentLine)
                }
            }
        }
        return nil
    }
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            (linesForText! + linesForTextExtra!).forEach {
                $0.layer.removeAnimationForKey("horizontal move")
            }
            startHorizontalAnimation()            
        }
    }
    func deltasToSyncedPositions() -> [CGFloat?] {
        return linesForText!.map { deltaToSyncedPosition(nextLine($0), currentLine: $0) }
    }
    func afterHorizontalAnimation(forLine: SingleLineTextView) {
        if let i = index(forLine) {
            var allLinesForText = [SingleLineTextView]()
            for k in 0..<linesForText!.count {
                allLinesForText.append(linesForText![k])
                allLinesForText.append(linesForTextExtra![k])
            }
            let j = i.index * 2 + (i.isForExtra ? 1 : 0)
            for x in 0..<j {
                let line = allLinesForText[x]
                if let targetPosition = targetPoint(line)?.point.x {
                    if line.frame.origin.x != targetPosition {
                        animateHorizontally(line)
                        break
                    }
                }
            }
        }
    }

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

extension SingleLineTextView {
    func animateHorizontally(fromLine: SingleLineTextView?, toLine: SingleLineTextView?, byDelta: CGFloat, delegate: AnyObject?){
        var from: SingleLineTextView?
        if let f = fromLine {
            if f.isEqual(self) {
                startHorizontalAnimation(byDelta, delegate: delegate)
                if f.isEqual(toLine!) {
                    if let extra = follower {
                        if f.frame.origin.y == extra.frame.origin.y {
                            (extra as! SingleLineTextView).startHorizontalAnimation(byDelta, delegate: delegate)
                        }
                    }
                    return
                }
            } else {
                from = fromLine
            }
        } else {
            if let t = toLine {
                startHorizontalAnimation(byDelta, delegate: delegate)
                if t.isEqual(self) {
                    if let f = follower {
                        (f as! SingleLineTextView).startHorizontalAnimation(byDelta, delegate: delegate)
                    }
                    return
                }
            } else {
                return
            }
        }
        if let f = follower {
            (f as! SingleLineTextView).animateHorizontally(from, toLine: toLine, byDelta: byDelta, delegate: delegate)
        }
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
        print("a:\(textRange.location + textRange.length), b: \((lastLineForText.text as NSString).length - 1)")
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

func textLines(textView: UITextView, fullTextView: UITextView? = nil) -> [SingleLineTextView] {
    return textView.singleLineTextViews(fullTextView)
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

