//
//  FootLockerWatcher.swift
//  saleAlert
//
//  Created by Liwei Zhang on 2016-03-07.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

let footlockerNikePerformanceBasketballShoeSize95 = "https://www.footlocker.ca/en-CA/Sale/Mens/Nike/Shoes/Performance-Basketball-Shoes/_-_/N-1z141w4Z24ZzzZrjZseZca"
let footlockerShoeNameAnchor = "quickviewEnabled" // Look for "title" follows.
let footlockerShoeNameEnd = "quickviewEnabled"
let footlockerShoeOriginalPriceAnchor = "product_price"
let footlockerShoeOriginalPriceEnd = "</B>"
let footlockerShoeSalePriceAnchor = "<B>Now"
let footlockerShoeSalePriceEnd = "</B>"





let aPairOfShoesInFootLocker = []

// From https://www.hackingwithswift.com/example-code/strings/how-to-load-a-string-from-a-file-in-your-bundle
func loadHTMLFromBundle() {
    if let filepath = NSBundle.mainBundle().pathForResource("Men's_nike_performanceBasketballShoe_9.5_FootLocker", ofType: "html") {
        do {
            let contents = try NSString(contentsOfFile: filepath, usedEncoding: nil) as String
            print(contents)
//            return content
        } catch {
            // contents could not be loaded
        }
    } else {
        // example.txt not found!
    }
}