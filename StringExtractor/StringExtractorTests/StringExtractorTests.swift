//
//  StringExtractorTests.swift
//  StringExtractor
//
//  Created by Liwei Zhang on 2016-03-08.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import XCTest
@testable import StringExtractor

let footlockerNikePerformanceBasketballShoeSize95 = "https://www.footlocker.ca/en-CA/Sale/Mens/Nike/Shoes/Performance-Basketball-Shoes/_-_/N-1z141w4Z24ZzzZrjZseZca"
let footlockerShoeNamePoint = "quickviewEnabled" // Look for "title" follows.
let footlockerShoeOriginalPricePoint = "product_price"
let footlockerShoeSalePricePoint = "<B>Now"

let footlockerShoeNameStart = "title=\""
let footlockerShoeNameEnd = "\" href="

let footlockerShoeDividers = [footlockerShoeNamePoint, footlockerShoeOriginalPricePoint, footlockerShoeSalePricePoint]

let Html1Item = "Men's_nike_performanceBasketballShoe_9.5_FootLocker_1item"
let Html2Items = "Men's_nike_performanceBasketballShoe_9.5_FootLocker_2items"


class StirngExtractorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
//
//
//    
//    
//    
//    
//    
//    
//    
    
    
    
}