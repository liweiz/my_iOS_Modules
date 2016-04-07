//
//  ViewController.swift
//  TextCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2016-03-21.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let text = "During the next launch cycle, the view attempts to restore these properties to their saved values. If the selection range cannot be applied to the text in the restored view, no text is selected. For more information about how state preservation and restoration works, see iOS App Programming Guide."
        let tView = UITextView(frame: CGRectMake(29, 30, 250, 500))
        view.addSubview(tView)
        tView.text = text
        tView.singleLineTextViews()
//        func mockTextView() {
//            let textView = UITextView(frame: CGRectMake(100, 40, 200, 150))
//            textView.text = text
//            let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
//            rootViewController?.view.addSubview(textView)
//            for index in textView.layoutManager.glyphRangeForTextContainer(textView.textContainer).location..<(textView.layoutManager.glyphRangeForTextContainer(textView.textContainer).location + textView.layoutManager.glyphRangeForTextContainer(textView.textContainer).length) {
//                let characterIndex = textView.layoutManager.characterIndexForGlyphAtIndex(index)
//                let characterString = (textView.text as NSString).substringWithRange(NSMakeRange(characterIndex, 1))
//                let locationY = textView.layoutManager.lineFragmentRectForGlyphAtIndex(index, effectiveRange: nil).origin.y
//                let lineRect = textView.layoutManager.lineFragmentRectForGlyphAtIndex(index, effectiveRange: nil)
//                print("glyph: \(index), \(characterString), \(locationY), \(lineRect)")
//            }
//        }
//        mockTextView()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

