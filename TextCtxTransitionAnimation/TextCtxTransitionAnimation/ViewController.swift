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
        let text = " cycle, the view attempts to restore these properties to their saved values. If the selection range  cannot be applied to the text in the restored view, no text is selected. For more information about how state preservation and restoration"
        let ctx = "During the next launch cycle, the view attempts to restore these properties to their saved values. If the selection range  cannot be applied to the text in the restored view, no text is selected. For more information about how state preservation and restoration works, see iOS App Programming Guide."
        
        let textView = UITextView(frame: CGRectMake(20, 30, view.bounds.width - 20 * 2, view.bounds.height - 30 * 2))
        let ctxView = UITextView(frame: CGRectMake(20, 300, view.bounds.width - 20 * 2, view.bounds.height - 90 * 2))
        textView.textContainer.lineFragmentPadding = 0
        ctxView.textContainer.lineFragmentPadding = 0
        view.addSubview(textView)
        view.addSubview(ctxView)
        textView.hidden = true
//        ctxView.hidden = true
        textView.text = text
        ctxView.text = ctx
        let controller = TransitionController(textView: textView, ctxView: ctxView, width: textView.frame.width)
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
        let button = UIView(frame: CGRectMake(50, 400, 40, 40))
        button.backgroundColor = UIColor.blackColor()
        view.addSubview(button)
        let tap = UITapGestureRecognizer(target: controller, action: #selector(controller.startAnimation))
        button.addGestureRecognizer(tap)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

