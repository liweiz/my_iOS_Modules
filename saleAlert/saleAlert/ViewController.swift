//
//  ViewController.swift
//  saleAlert
//
//  Created by Liwei Zhang on 2016-02-28.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Alamofire.request(.GET, footlockerNikePerformanceBasketballShoeSize95).responseString {
            responsedString in
            if let s = responsedString.result.value {
                print(s)
                print
                var stringLeft = s
                while stringLeft.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                    
                }
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

