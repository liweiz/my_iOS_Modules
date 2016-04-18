//
//  TransitionController.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-04-07.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
}

protocol ConversionBetweenCharRangeAndGeometry {
    func deltaOfOrigins(fromCharRange: NSRange, toCharRange: NSRange) -> CGPoint?
    func rectOrigin(forCharRange: NSRange) -> CGPoint
    func rectInTextContainerCoordinates(forCharRange: NSRange) -> CGRect
}

extension ConversionBetweenCharRangeAndGeometry where Self: UITextView {
    /// deltaOfOriginXs returns the distance between two origins.
    func deltaOfOrigins(fromCharRange: NSRange, toCharRange: NSRange) -> CGPoint? {
        let length = (text as NSString).length
        if fromCharRange.location + fromCharRange.length > length || toCharRange.location + toCharRange.length > length || fromCharRange.length * toCharRange.length == 0 { return nil }
        let fromOrigin = rectInTextContainerCoordinates(fromCharRange).origin
        let toOrigin = rectInTextContainerCoordinates(toCharRange).origin
        return fromOrigin.deltaTo(toOrigin)
    }
    func rectOrigin(forCharRange: NSRange) -> CGPoint {
        let charOriginRaw = rectInTextContainerCoordinates(forCharRange).origin
        return convertFromTextContainerCoordinatesToSelf(charOriginRaw)
    }
    func rectInTextContainerCoordinates(forCharRange: NSRange) -> CGRect {
        return layoutManager.boundingRectForGlyphRange(layoutManager.glyphRangeForCharacterRange(forCharRange, actualCharacterRange: nil), inTextContainer: textContainer)
    }
}

extension UITextView: ConversionBetweenCharRangeAndGeometry {}

protocol LinesGeneratable {
    func oneLiners(textTargeted: String) -> (lines: [SingleLineInCtx], charRanges: [NSRange])?
    func oneLiners(inCtxView: UITextView?) -> [SingleLineInCtx]
    
}

extension LinesGeneratable where Self: UITextView {
    func oneLiners(textTargeted: String) -> (lines: [SingleLineInCtx], charRanges: [NSRange])? {
        var lines = [SingleLineInCtx]()
        var ranges = [NSRange]()
        let range = (text as NSString).rangeOfString(textTargeted)
        if range.location == NSNotFound { return nil }
        var lineIndices = [Int]()
        var i = 0
        for charRange in charRangesForEachLine! {
            if NSIntersectionRange(charRange, range).length > 0 {
                lineIndices.append(i)
                ranges.append(charRange)
            }
            i += 1
        }
        let views = oneLiners()
        for index in lineIndices {
            lines.append(views[index])
        }
        return (lines, ranges)
    }
    /// SingleLinesInCtx return SingleLineInCtxs that overlap with each line.
    func oneLiners(inCtxView: UITextView? = nil) -> [SingleLineInCtx] {
        var singleLineTextViews = [SingleLineInCtx]()
        if let rects = lineFragmentRectForEachLineNoPadding {
            let fullTextView = (inCtxView == nil ? self : inCtxView!)
            var i = 0
            for rect in rects {
                let chars = (text as NSString).substringWithRange(charRangesForEachLine![i])
                print("chars: \(chars)")
                let rangeInFullTextView = (fullTextView.text as NSString).rangeOfString(chars)
                let lineView = SingleLineInCtx(attriText: fullTextView.attributedText, lineHeight: rect.height)
                let lineViewImitatedTextRectOrigin = lineView.rectOrigin(rangeInFullTextView)
                let lineCharOrigin = (self as UITextView).rectOrigin(charRangesForEachLine![i])
                addSubview(lineView)
                lineView.frame.origin = lineView.originToMatch(lineCharOrigin, anotherView: self, pointHere: lineViewImitatedTextRectOrigin)
                singleLineTextViews.append(lineView)
                i += 1
            }
        }
        return singleLineTextViews
    }
    
}

extension UITextView: LinesGeneratable {}

protocol TextCtxTransitionReady {
    var main: [SingleLineInCtx] { get }
    var extra: [SingleLineInCtx] { get }
    func index(forLine: SingleLineInCtx) -> (isForExtra: Bool, index: Int)?
    func nextLine(currentLine: SingleLineInCtx) -> SingleLineInCtx?
    func setTextToCtxFollowers()
    func matchNoOfLinesBetween(textLines: [SingleLineInCtx], filteredCtxLines: [SingleLineInCtx], lineWidth: CGFloat) -> [SingleLineInCtx]
    func visiableEachLineCharRanges(eachLineContentInText: [String], filteredCtxLineCharRanges: [NSRange], ctx: String) -> (mainCharRanges: [NSRange], extraCharRanges: [NSRange])
}

extension TextCtxTransitionReady {
    func index(forLine: SingleLineInCtx) -> (isForExtra: Bool, index: Int)? {
        if let i = main.indexOf(forLine) { return (false, i) }
        if let i = extra.indexOf(forLine) { return (true , i) }
        return nil
    }
    func nextLine(currentLine: SingleLineInCtx) -> SingleLineInCtx? {
        if let index = main.indexOf(currentLine) {
            return index == main.count - 1 ? nil : main[index + 1]
        } else if extra.contains(currentLine) {
            return currentLine.follower as? SingleLineInCtx
        }
        return nil
    }
    func setTextToCtxFollowers() {
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
    func matchNoOfLinesBetween(textLines: [SingleLineInCtx], filteredCtxLines: [SingleLineInCtx], lineWidth: CGFloat) -> [SingleLineInCtx] {
        if filteredCtxLines.count > textLines.count && filteredCtxLines.count > 1 {
            let gap = filteredCtxLines[1].frame.origin.y - filteredCtxLines[0].frame.maxY
            let extraTextLine = extraLineForText(textLines.last!, verticalLineFragmentGap: gap, lineWidth: lineWidth)
            textLines.first?.superview?.addSubview(extraTextLine)
            return textLines + [extraTextLine]
        }
        return textLines
    }
    func extraLineForText(lastLineForText: SingleLineInCtx, verticalLineFragmentGap: CGFloat, lineWidth: CGFloat) -> SingleLineInCtx {
        let y = lastLineForText.frame.maxY + verticalLineFragmentGap
        var x: CGFloat = 0
        x = lastLineForText.frame.origin.x - lineWidth
        let extraLine = SingleLineInCtx(attriText: lastLineForText.attributedText, lineHeight: lastLineForText.frame.size.height)
        extraLine.frame.origin = CGPointMake(x, y)
        lastLineForText.superview!.addSubview(extraLine)
        return extraLine
    }
    /// visiableEachLineCharRanges returns the charRange visiable in each line. NSNotFound indicates the whole line should be invisiable.
    func visiableEachLineCharRanges(eachLineContentInText: [String], filteredCtxLineCharRanges: [NSRange], ctx: String) -> (mainCharRanges: [NSRange], extraCharRanges: [NSRange]) {
        func endLocation(ofRange: NSRange) -> Int {
            return ofRange.location + ofRange.length - 1
        }
        if eachLineContentInText.count == filteredCtxLineCharRanges.count {
            let eachLineContentInTextCharRangesInCtx = eachLineContentInText.map { (ctx as NSString).rangeOfString($0) }
            var mainRanges = [NSRange]()
            for i in 0..<filteredCtxLineCharRanges.count {
                let textStartLocation = eachLineContentInTextCharRangesInCtx[i].location
                if textStartLocation == NSNotFound {
                    mainRanges.append(NSMakeRange(eachLineContentInTextCharRangesInCtx[0].location, (eachLineContentInTextCharRangesInCtx.map { $0.length }).reduce(0, combine: { $0 + $1 })))
                } else {
                    let textEndLocation = endLocation(eachLineContentInTextCharRangesInCtx[i])
                    let ctxStartLocation = filteredCtxLineCharRanges[i].location
                    let ctxEndLocation = endLocation(filteredCtxLineCharRanges[i])
                    let start = i == 0 ? textStartLocation : min(textStartLocation, ctxStartLocation)
                    let end = min(textEndLocation, ctxEndLocation)
                    mainRanges.append(NSMakeRange(start, end - start + 1))
                }
                print("mainString for line index \(i): \((ctx as NSString).substringWithRange(mainRanges.last!))")
            }
            var extraRanges = [NSRange]()
            for i in 0..<filteredCtxLineCharRanges.count {
                if i < filteredCtxLineCharRanges.count - 1 {
                    let start = mainRanges[i].location + mainRanges[i].length
                    let nextTextStartLocation = eachLineContentInTextCharRangesInCtx[i + 1].location
                    if nextTextStartLocation == NSNotFound {
                        extraRanges.append(NSMakeRange(start, eachLineContentInTextCharRangesInCtx[0].location + (eachLineContentInTextCharRangesInCtx.map { $0.length }).reduce(0, combine: { $0 + $1 }) - start))
                    } else {
                        let end = nextTextStartLocation - 1
                        if start > end {
                            extraRanges.append(NSMakeRange(NSNotFound, 0))
                        } else {
                            extraRanges.append(NSMakeRange(start, end - start + 1))
                        }
                    }
                } else {
                    extraRanges.append(NSMakeRange(NSNotFound, 0))
                }
                extraRanges.last!.location == NSNotFound ? print("line is hidden") : print("extraString for line index \(i): \((ctx as NSString).substringWithRange(extraRanges.last!))")
            }
            return (mainRanges, extraRanges)
        }
        return visiableEachLineCharRanges(eachLineContentInText + [""], filteredCtxLineCharRanges: filteredCtxLineCharRanges, ctx: ctx)
    }
}

protocol DynamicsInTransition: TextCtxTransitionReady {
    func deepDeltaToSyncedPosition(withNextLine: SingleLineInCtx?, currentLine: SingleLineInCtx, lineWidth: CGFloat) -> (delta: CGFloat, deepLine: SingleLineInCtx)?
    func deltaToSyncedPosition(ofNextLine: SingleLineInCtx?, currentLine: SingleLineInCtx, lineWidth: CGFloat) -> CGFloat?
    func targetPoint(forLine: SingleLineInCtx, filteredCtx: [SingleLineInCtx], lineWidth: CGFloat) -> (isForExtra: Bool, point: CGPoint)?
}

extension DynamicsInTransition {
    /// deepDeltaToSyncedPosition returns the delta to sync for closet line below. Nil is returned, if all lines below are synced.
    func deepDeltaToSyncedPosition(withNextLine: SingleLineInCtx?, currentLine: SingleLineInCtx, lineWidth: CGFloat) -> (delta: CGFloat, deepLine: SingleLineInCtx)? {
        if let next = withNextLine {
            // Make sure following lines are synced before animation.
            if let delta = deltaToSyncedPosition(next, currentLine: currentLine, lineWidth: lineWidth) {
                switch delta {
                case 0:
                    print("animation: synced, ready to move freely.")
                    return deepDeltaToSyncedPosition(nextLine(next), currentLine: next, lineWidth: lineWidth)
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
    func deltaToSyncedPosition(ofNextLine: SingleLineInCtx?, currentLine: SingleLineInCtx, lineWidth: CGFloat) -> CGFloat? {
        if let next = ofNextLine {
            return currentLine.frame.origin.x - (next.frame.origin.x + lineWidth)
        }
        return nil
    }
    func targetPoint(forLine: SingleLineInCtx, filteredCtx: [SingleLineInCtx], lineWidth: CGFloat) -> (isForExtra: Bool, point: CGPoint)? {
        let t = targetPointRaw(forLine, filteredCtx: filteredCtx, lineWidth: lineWidth)
        if let targetRaw = t {
            if targetRaw.isForExtra {
                if let nextline = forLine.follower as? SingleLineInCtx {
                    if let nextLineTargetRaw = targetPointRaw(nextline, filteredCtx: filteredCtx, lineWidth: lineWidth) {
                        if nextLineTargetRaw.point.x == nextline.frame.origin.x {
                            return (targetRaw.isForExtra, forLine.frame.origin)
                        }
                    }
                }
            }
        }
        return t
    }
    func targetPointRaw(forLine: SingleLineInCtx, filteredCtx: [SingleLineInCtx], lineWidth: CGFloat) -> (isForExtra: Bool, point: CGPoint)? {
        if let i = index(forLine) {
            let correspondingLineOrigin = (filteredCtx.map { $0.frame.origin })[i.index]
            if i.isForExtra {
                if i.index + 1 < extra.count {
                    let x = (filteredCtx.map { $0.frame.origin })[i.index + 1].x + lineWidth
                    return (i.isForExtra, CGPointMake(x, correspondingLineOrigin.y))
                }
            } else {
                return (i.isForExtra, correspondingLineOrigin)
            }
        }
        return nil
    }
}

extension TransitionController: DynamicsInTransition {}

class TransitionController: UIViewController {
    var textView: UITextView?
    var ctxView: UITextView?
    var width: CGFloat?
    var linesForText: [SingleLineInCtx]?
    var linesForTextExtra: [SingleLineInCtx]?
    var main: [SingleLineInCtx] {
        if let m = linesForText {
            return m
        }
        return [SingleLineInCtx]()
    }
    var extra: [SingleLineInCtx] {
        if let e = linesForTextExtra {
            return e
        }
        return [SingleLineInCtx]()
    }
    var filteredCharRangesForLinesInCtx: [NSRange]?
    var filteredLinesForCtx: [SingleLineInCtx]?
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
        setupLines()
    }
    func moveToSelfView(views: [UIView], fromView: UIView) {
        views.forEach {
            $0.frame.origin = view.convertPoint($0.frame.origin, fromView: fromView)
            $0.removeFromSuperview()
            view.addSubview($0)
        }
    }
    func setupLines() {
        linesForText = textView!.oneLiners(ctxView)
        if let filteredLinesAndCharRangesForCtx = ctxView!.oneLiners(textView!.text) {
            filteredLinesForCtx = filteredLinesAndCharRangesForCtx.lines
            filteredCharRangesForLinesInCtx = filteredLinesAndCharRangesForCtx.charRanges
        } else {
            return
        }
        if linesForText!.count * filteredLinesForCtx!.count > 0 {
            moveToSelfView(linesForText!, fromView: textView!)
            moveToSelfView(filteredLinesForCtx!, fromView: ctxView!)
            linesForText = matchNoOfLinesBetween(linesForText!, filteredCtxLines: filteredLinesForCtx!, lineWidth: view.bounds.width)
            linesForTextExtra = [SingleLineInCtx]()
            for l in linesForText! {
                let lExtra = SingleLineInCtx(attriText: l.attributedText, lineHeight: l.frame.size.height)
                lExtra.frame = l.frame
                view.addSubview(lExtra)
                linesForTextExtra?.append(lExtra)
            }
            setTextToCtxFollowers()
            filteredLinesForCtx!.forEach { $0.hidden = true }
            linesForText!.forEach {
                $0.tag = 100 + linesForText!.indexOf($0)!
            }
            linesForTextExtra!.forEach {
                $0.tag = 1000 + linesForTextExtra!.indexOf($0)!
            }
        }
        setVisiablePartForEachLine()
    }
    var fontColor: UIColor {
        return textView!.attributedText.attribute(NSForegroundColorAttributeName, atIndex: 0, effectiveRange: nil) as! UIColor
    }
    func setVisiablePartForEachLine(color: UIColor? = nil) {
        let ranges = visiableEachLineCharRanges(textView!.charRangesForEachLine!.map { (textView!.text as NSString).substringWithRange($0) }, filteredCtxLineCharRanges: filteredCharRangesForLinesInCtx!, ctx: ctxView!.text)
        let visiableFontColor = UIColor.lightGrayColor() //(color == nil ? fontColor : color!)
        for i in 0..<ranges.mainCharRanges.count {
            let mainAttriText = NSMutableAttributedString(attributedString: linesForText![i].attributedText)
            let fullCharRange = NSMakeRange(0, (ctxView!.text as NSString).length)
            mainAttriText.addAttribute(NSForegroundColorAttributeName, value: UIColor.clearColor(), range: fullCharRange)
            mainAttriText.addAttribute(NSForegroundColorAttributeName, value: visiableFontColor, range: ranges.mainCharRanges[i])
            linesForText![i].attributedText = mainAttriText
            let extraAttriText = NSMutableAttributedString(attributedString: linesForTextExtra![i].attributedText)
            extraAttriText.addAttribute(NSForegroundColorAttributeName, value: UIColor.clearColor(), range: fullCharRange)
            extraAttriText.addAttribute(NSForegroundColorAttributeName, value: visiableFontColor, range: ranges.extraCharRanges[i])
            linesForTextExtra![i].attributedText = extraAttriText
        }
    }
    
    func startHorizontalAnimation() {
        animateHorizontally((linesForText?.first!)!)
    }
    var totalAnimationDuration: NSTimeInterval = 5
    var horizontalAnimationDuration: NSTimeInterval {
        return totalAnimationDuration / Double(main.count == 0 ? 1 : main.count)
    }
    func animateHorizontally(line: SingleLineInCtx) {
        if let target = targetPoint(line, filteredCtx: filteredLinesForCtx!, lineWidth: view.bounds.width) {
            let targetPosition = target.point.x
            let deltaMax = targetPosition - line.frame.origin.x
            if deltaMax == 0 {
                // Animation for SingleLineTextView all done, pass to next one.
                if let follower = line.follower {
                    animateHorizontally(follower as! SingleLineInCtx)
                }
            } else {
                var delta: CGFloat = 0
                var firstLineToMove: SingleLineInCtx
                if let next = nextLine(line) {
                    // Make sure following lines are synced before animation.
                    if let deepDeltaToSync = deepDeltaToSyncedPosition(next, currentLine: line, lineWidth: view.bounds.width) {
                        if deepDeltaToSync.delta > 0 {
                            // Sync with min distance.
                            delta = min(deltaMax, deepDeltaToSync.delta)
                            firstLineToMove = line
                        } else {
                            // Sync next line to match current line.
                            delta = abs(deepDeltaToSync.delta)
                            firstLineToMove = next
                        }
                        print("total line no: \(linesForText?.count); lineToMove index: main: \(linesForText?.indexOf(firstLineToMove)), extra: \(linesForTextExtra?.indexOf(firstLineToMove)); toLine index: main: \(linesForText?.indexOf(deepDeltaToSync.deepLine)), extra: \(linesForTextExtra?.indexOf(deepDeltaToSync.deepLine))")
                        firstLineToMove.animateHorizontallyBetween(firstLineToMove, toLine: deepDeltaToSync.deepLine, byDelta: delta, duration: horizontalAnimationDuration, delegate: self)
                    } else {
                        delta = deltaMax
                        firstLineToMove = line
                        firstLineToMove.animateHorizontallyBetween(firstLineToMove, toLine: linesForText!.last!, byDelta: delta, duration: horizontalAnimationDuration, delegate: self)
                    }
                    idOfLineStartedHorizontalAnimation = firstLineToMove.tag
                    return
                }
                idOfLineStartedHorizontalAnimation = line.tag
                animateOneLineHorizontally(line, byDelta: deltaMax)
            }
        }
    }
    func animateOneLineHorizontally(line: SingleLineInCtx, byDelta: CGFloat) {
        line.startHorizontalAnimation(byDelta, duration: horizontalAnimationDuration, delegate: self)
        if line.follower!.frame.origin.y == line.frame.origin.y {
            (line.follower! as! SingleLineInCtx).startHorizontalAnimation(byDelta, duration: horizontalAnimationDuration, delegate: self)
        }
    }
    
    var idOfLineStartedHorizontalAnimation = 0
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            if anim.valueForKey("view tag") as! Int == idOfLineStartedHorizontalAnimation {
                (linesForText! + linesForTextExtra!).forEach {
                    $0.layer.removeAnimationForKey("horizontal move")
                }
                startHorizontalAnimation()
            }
        }
    }
}

extension SingleLineInCtx {
    func animateHorizontallyBetween(fromLine: SingleLineTextView?, toLine: SingleLineTextView?, byDelta: CGFloat, duration: NSTimeInterval, delegate: TextCtxTransitionReady){
        var from: SingleLineTextView?
        if let startLine = fromLine {
            if startLine.isEqual(self) {
                startHorizontalAnimation(byDelta, duration: duration, delegate: (delegate as? AnyObject))
                if startLine.isEqual(toLine!) {
                    animateLineExtraHorizontally(byDelta, duration: duration, delegate: delegate)
                    return
                }
            } else {
                from = fromLine
            }
        } else {
            if let endLine = toLine {
                startHorizontalAnimation(byDelta, duration: duration, delegate: (delegate as? AnyObject))
                if endLine.isEqual(self) {
                    animateLineExtraHorizontally(byDelta, duration: duration, delegate: delegate)
                    return
                }
            } else {
                return
            }
        }
        if let f = follower {
            (f as! SingleLineInCtx).animateHorizontallyBetween(from, toLine: toLine, byDelta: byDelta, duration: duration, delegate: delegate)
        }
    }
}

protocol LineExtra {
    func animateLineExtraHorizontally(byDelta: CGFloat, duration: NSTimeInterval, delegate: TextCtxTransitionReady)
}

extension LineExtra where Self: SingleLineInCtx {
    func animateLineExtraHorizontally(byDelta: CGFloat, duration: NSTimeInterval, delegate: TextCtxTransitionReady) {
        if let index = delegate.main.indexOf(self) {
            if let f = follower {
                if delegate.extra[index].isEqual(f) {
                    (f as! SingleLineTextView).startHorizontalAnimation(byDelta, duration: duration, delegate: (delegate as? AnyObject))
                }
            }
        }
    }
}

extension SingleLineInCtx: LineExtra {}