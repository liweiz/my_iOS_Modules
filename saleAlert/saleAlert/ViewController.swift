//
//  ViewController.swift
//  saleAlert
//
//  Created by Liwei Zhang on 2016-02-28.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let footlockerNikePerformanceBasketballShoeSize95 = "https://www.footlocker.ca/en-CA/Sale/Mens/Nike/Shoes/Performance-Basketball-Shoes/_-_/N-1z141w4Z24ZzzZrjZseZca"
        let footlockerShoeNameAnchor = "quickviewEnabled" // Look for "title" follows.
        let footlockerShoeNameEnd = "quickviewEnabled"
        let footlockerShoeOriginalPriceAnchor = "product_price"
        let footlockerShoeOriginalPriceEnd = "</B>"
        let footlockerShoeSalePriceAnchor = "<B>Now"
        let footlockerShoeSalePriceEnd = "</B>"
        Alamofire.request(.GET, footlockerNikePerformanceBasketballShoeSize95).responseString {
            responsedString in
            if let s = responsedString.result.value {
                print(s)
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

