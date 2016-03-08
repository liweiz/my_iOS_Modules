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





struct TextContentLayer {
    let startTextAnchors: [String]?
    let parentStartText: String
}