//
//  ViewController.swift
//  AdvanceSample-tvOS
//
//  Created by Timothy Donnelly on 3/18/16.
//  Copyright © 2016 Storehouse Media Inc. All rights reserved.
//

import UIKit
import Advance

class ViewController: UIViewController {
    
    var positionWhenPanBegan = CGPoint.zero
    
    let panRecognizer = UIPanGestureRecognizer()
    
    let dot = UIView(frame: CGRect.zero)
    
    let spring = Spring(value: CGPoint.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        panRecognizer.addTarget(self, action: #selector(pan(_:)))
        view.addGestureRecognizer(panRecognizer)
    
    
        dot.bounds = CGRect(x: 0.0, y: 0.0, width: 64.0, height: 64.0)
        dot.layer.cornerRadius = 32.0
        dot.backgroundColor = UIColor(red: 0.0, green: 196.0/255.0, blue: 1.0, alpha: 1.0)
        view.addSubview(dot)
        
        spring.changed.observe { [unowned self] (point) in
            self.dot.center = point
        }
        
        spring.reset(CGPoint(x: view.bounds.midX, y: view.bounds.midY))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    dynamic func pan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            positionWhenPanBegan = spring.value
        case .Changed:
            var pos = positionWhenPanBegan
            pos.x += sender.translationInView(view).x
            pos.y += sender.translationInView(view).y
            spring.reset(pos)
        case .Ended:
            spring.velocity = sender.velocityInView(view)
            spring.target = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        default:
            break
        }
    }

}

