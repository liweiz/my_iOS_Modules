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
    func line()
    func visiableEachLineCharRanges(eachLineContentInText: [String], filteredCtxLineCharRanges: [NSRange], ctx: String) -> (mainCharRanges: [NSRange], extraCharRanges: [NSRange])
}

extension TextCtxTransitionReady {
    func matchNoOfLines(textLines: [SingleLineInCtx], filteredCtxLines: [SingleLineInCtx]) -> (matchedTextLines: [SingleLineInCtx], updatedDeltasFromTextToCtxEachLine: [CGFloat]) {
        if filteredCtxLines.count > textLines.count && filteredCtxLines.count > 1 {
            let gap = filteredCtxLines[1].frame.origin.y - filteredCtxLines[0].frame.maxY
            let extraTextLine = extraLineForText(textLines.last!, verticalLineFragmentGap: gap)
            return (textLines + [extraTextLine], deltasFromTextToCtxEachLine + [extraTextLine.frame.origin.deltaTo(filteredLinesForCtx!.last!.frame.origin)])
        }
    }
    func extraLineForText(lastLineForText: SingleLineInCtx, verticalLineFragmentGap: CGFloat) -> SingleLineInCtx {
        let y = lastLineForText.frame.maxY + verticalLineFragmentGap
        var x: CGFloat = 0
        x = lastLineForText.frame.origin.x - lastLineForText.frame.size.width
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
                    mainRanges.append(filteredCtxLineCharRanges[i])
                } else {
                    let textEndLocation = endLocation(eachLineContentInTextCharRangesInCtx[i])
                    let ctxStartLocation = filteredCtxLineCharRanges[i].location
                    let ctxEndLocation = endLocation(filteredCtxLineCharRanges[i])
                    let start = min(textStartLocation, ctxStartLocation)
                    let end = max(textEndLocation, ctxEndLocation)
                    mainRanges.append(NSMakeRange(start, end - start + 1))
                }
            }
            var extraRanges = [NSRange]()
            for i in 0..<filteredCtxLineCharRanges.count {
                if i < filteredCtxLineCharRanges.count - 1 {
                    let start = mainRanges[i].location + mainRanges[i].length
                    let nextTextStartLocation = eachLineContentInTextCharRangesInCtx[i + 1].location
                    if nextTextStartLocation == NSNotFound {
                        extraRanges.append(NSMakeRange(NSNotFound, 0))
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
            }
            return (mainRanges, extraRanges)
        }
        return visiableEachLineCharRanges(eachLineContentInText + [""], filteredCtxLineCharRanges: filteredCtxLineCharRanges, ctx: ctx)
    }
}

class TransitionController: UIViewController {
    var textView: UITextView?
    var ctxView: UITextView?
    var width: CGFloat?
    var linesForText: [SingleLineInCtx]?
    var linesForTextExtra: [SingleLineInCtx]?
    var filteredCharRangesForLinesInCtx: [NSRange]?
    var deltasFromTextToCtxEachLine = [CGPoint]()
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
        linesForText = textView!.OneLiners(ctxView)
        if let filteredLinesAndCharRangesForCtx = ctxView!.OneLiners(textView!.text) {
            filteredLinesForCtx = filteredLinesAndCharRangesForCtx.lines
            filteredCharRangesForLinesInCtx = filteredLinesAndCharRangesForCtx.charRanges
        }
        
        if linesForText!.count < filteredLinesForCtx!.count {
//            let line =
        }
        if linesForText!.count * filteredLinesForCtx!.count > 0 {
            moveToSelfView(linesForText!, fromView: textView!)
            moveToSelfView(filteredLinesForCtx!, fromView: ctxView!)
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
            
            setTextToCtxFollowers(linesForText!, extra: linesForTextExtra!)
            filteredLinesForCtx!.forEach { $0.hidden = true }
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
        idOfLineStartedHorizontalAnimation = "\(line.frame.origin) \(line.followerIsShadow)"
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
                var firstLineToMove: SingleLineTextView
                if let next = nextLine(line) {
                    // Make sure following lines are synced before animation.
                    if let deepDeltaToSync = deepDeltaToSyncedPosition(next, currentLine: line) {
                        if deepDeltaToSync.delta > 0 {
                            // Sync with min distance.
                            delta = min(deltaMax, deepDeltaToSync.delta)
                            firstLineToMove = line
//                        } else if deepDeltaToSync.delta == 0 {
//                            // All lines below are synced. But 0 will never be returned.
////                            delta = deltaMax
//                            firstLineToMove = line
                        } else {
                            // Sync next line to match current line.
                            delta = abs(deepDeltaToSync.delta)
                            firstLineToMove = next
                        }
                        print("total line no: \(linesForText?.count); lineToMove index: main: \(linesForText?.indexOf(firstLineToMove)), extra: \(linesForTextExtra?.indexOf(firstLineToMove)); toLine index: main: \(linesForText?.indexOf(deepDeltaToSync.deepLine)), extra: \(linesForTextExtra?.indexOf(deepDeltaToSync.deepLine))")
                        firstLineToMove.animateHorizontallyBetween(firstLineToMove, toLine: deepDeltaToSync.deepLine, byDelta: delta, delegate: self)
                    } else {
                        delta = deltaMax
                        firstLineToMove = line
                        firstLineToMove.animateHorizontallyBetween(firstLineToMove, toLine: linesForText!.last!, byDelta: delta, delegate: self)
                    }
                    return
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
    /// deepDeltaToSyncedPosition returns the delta to sync for closet line below. Nil is returned, if all lines below are synced.
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
    var idOfLineStartedHorizontalAnimation = ""
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag {
            if anim.valueForKey("ID")!.isEqualToString(idOfLineStartedHorizontalAnimation) {
                (linesForText! + linesForTextExtra!).forEach {
                    $0.layer.removeAnimationForKey("horizontal move")
                }
                startHorizontalAnimation()
            }
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




extension SingleLineInCtx {
    func animateHorizontallyBetween(fromLine: SingleLineTextView?, toLine: SingleLineTextView?, byDelta: CGFloat, duration: NSTimeInterval, delegate: AnyObject?){
        var from: SingleLineTextView?
        if let startLine = fromLine {
            if startLine.isEqual(self) {
                startHorizontalAnimation(byDelta, duration: duration, delegate: delegate)
                if startLine.isEqual(toLine!) {
                    animateLineExtraHorizontally(byDelta, duration: duration, delegate: delegate)
                    return
                }
            } else {
                from = fromLine
            }
        } else {
            if let endLine = toLine {
                startHorizontalAnimation(byDelta, duration: duration, delegate: delegate)
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
    var followerIsLineExtra: Bool? { get }
    func animateLineExtraHorizontally(byDelta: CGFloat, duration: NSTimeInterval, delegate: AnyObject?)
}

extension LineExtra where Self: SingleLineInCtx {
    var followerIsLineExtra: Bool? {
        if let f = follower {
            return f.frame == frame
        }
        return nil
    }
    func animateLineExtraHorizontally(byDelta: CGFloat, duration: NSTimeInterval, delegate: AnyObject?) {
        if let f = followerIsLineExtra {
            if f {
                (follower as! SingleLineTextView).startHorizontalAnimation(byDelta, duration: duration, delegate: delegate)
            }
        }
    }
}

extension SingleLineInCtx: LineExtra {}







