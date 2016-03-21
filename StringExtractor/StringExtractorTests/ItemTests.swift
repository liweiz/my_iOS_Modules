//
//  ItemTests.swift
//  StringExtractor
//
//  Created by Liwei Zhang on 2016-03-20.
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
let Html37Items = "Nike_Men_95_running_shoe_37items"

class ItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllItems() {
        struct Tests {
            let testName: String
            let fromString: String
            let dividersAndStringLocators: [(String, (String, String)?)]
            let specifications: [String: String]
            let seller: String
            let expectedOutput: [Item]
        }
        let toTests = [
            Tests(
                testName: "found",
                fromString: loadHTMLFromBundle(Html2Items),
                dividersAndStringLocators: [(footlockerShoeNamePoint,
                    (footlockerShoeNameStart, footlockerShoeNameEnd)),
                    (footlockerShoeOriginalPricePoint, nil), (footlockerShoeSalePricePoint, nil)],
                specifications: ["size": "9.5"],
                seller: "footlocker",
                expectedOutput: [
                    Item(
                        name: "Nike LeBron Zoom Soldier IX  - Men's - Blue / White",
                        originalPrice: "165.00",
                        salePrice: "139.99",
                        specifications: ["size": "9.5"],
                        seller: "footlocker"),
                    Item(
                        name: "Nike Air Visi Pro IV  - Men's - Grey / Black",
                        originalPrice: "94.99",
                        salePrice: "79.99",
                        specifications: ["size": "9.5"],
                        seller: "footlocker")])
        ]
        let testFuncName = "allItem"
        var i = 0
        for t in toTests {
            printStart(testFuncName, testName: t.testName, testIndex: i)
            let outcome = allItems(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller)
            XCTAssertEqual(outcome[0].name, t.expectedOutput[0].name)
            XCTAssertEqual(outcome[1].name, t.expectedOutput[1].name)
            XCTAssertEqual(outcome[0].originalPrice, t.expectedOutput[0].originalPrice)
            XCTAssertEqual(outcome[1].originalPrice, t.expectedOutput[1].originalPrice)
            XCTAssertEqual(outcome[0].salePrice, t.expectedOutput[0].salePrice)
            XCTAssertEqual(outcome[1].salePrice, t.expectedOutput[1].salePrice)
            printEnd(testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
    func testItem() {
        struct Tests {
            let testName: String
            let fromString: String
            let dividersAndStringLocators: [(String, (String, String)?)]
            let specifications: [String: String]
            let seller: String
            let expectedOutput: Item?
        }
        let toTests = [
            Tests(
                testName: "found",
                fromString: loadHTMLFromBundle(Html1Item),
                dividersAndStringLocators: [(footlockerShoeNamePoint,
                    (footlockerShoeNameStart, footlockerShoeNameEnd)),
                    (footlockerShoeOriginalPricePoint, nil), (footlockerShoeSalePricePoint, nil)],
                specifications: ["size": "9.5"],
                seller: "footlocker",
                expectedOutput: Item(
                    name: "Nike LeBron Zoom Soldier IX  - Men's - Blue / White",
                    originalPrice: "167.00",
                    salePrice: "139.99",
                    specifications: ["size": "9.5"],
                    seller: "footlocker"))
        ]
        let testFuncName = "item"
        var i = 0
        for t in toTests {
            printStart(testFuncName, testName: t.testName, testIndex: i)
            let outcome = item(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller)
            XCTAssertEqual(outcome.0?.name, t.expectedOutput?.name)
            XCTAssertEqual(outcome.0?.originalPrice, t.expectedOutput?.originalPrice)
            XCTAssertEqual(outcome.0?.salePrice, t.expectedOutput?.salePrice)
            XCTAssertEqual((outcome.0?.specifications)!, (t.expectedOutput?.specifications)!)
            XCTAssertEqual(outcome.0?.seller, t.expectedOutput?.seller)
            XCTAssertEqual(outcome.0?.discount, t.expectedOutput?.discount)
            printEnd(testFuncName, testName: t.testName, testIndex: i)
            i += 1
        }
    }
}
