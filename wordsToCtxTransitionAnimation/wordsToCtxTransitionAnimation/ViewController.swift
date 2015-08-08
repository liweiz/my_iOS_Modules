//
//  ViewController.swift
//  wordsToCtxTransitionAnimation
//
//  Created by Liwei Zhang on 2015-08-06.
//  Copyright © 2015 Liwei Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view = UIView(frame: UIScreen.mainScreen().bounds)
        let view0 = UIView(frame: UIScreen.mainScreen().bounds)
        view0.backgroundColor = UIColor.orangeColor()
        let ctl = testAnimatableTextViewCtl(self, viewToAttachOn: view0)
        addChildViewController(ctl)
        view.addSubview(view0)
        ctl.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

