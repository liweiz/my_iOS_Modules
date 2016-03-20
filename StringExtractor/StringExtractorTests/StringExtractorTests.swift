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
    
//    func testAllItems() {
//        struct Tests {
//            let testName: String
//            let fromString: String
//            let dividersAndStringLocators: [(String, (String, String)?)]
//            let specifications: [String: String]
//            let seller: String
//            let expectedOutput: [Item]
//        }
//        let toTests = [
//            Tests(
//                testName: "allItem *** found",
//                fromString: loadHTMLFromBundle(Html2Items),
//                dividersAndStringLocators: [(footlockerShoeNamePoint,
//                    (footlockerShoeNameStart, footlockerShoeNameEnd)),
//                    (footlockerShoeOriginalPricePoint, nil), (footlockerShoeSalePricePoint, nil)],
//                specifications: ["size": "9.5"],
//                seller: "footlocker",
//                expectedOutput: [
//                    Item(
//                        name: "Nike LeBron Zoom Soldier IX  - Men's - Blue / White",
//                        originalPrice: "165.00",
//                        salePrice: "139.99",
//                        specifications: ["size": "9.5"],
//                        seller: "footlocker"),
//                    Item(
//                        name: "Nike Air Visi Pro IV  - Men's - Grey / Black",
//                        originalPrice: "94.99",
//                        salePrice: "79.99",
//                        specifications: ["size": "9.5"],
//                        seller: "footlocker")])
//        ]
//        for t in toTests {
//            print("TEST_NAME: " + t.testName + " *** START")
//            XCTAssertEqual(allItems(
//                t.fromString,
//                dividersAndStringLocators: t.dividersAndStringLocators,
//                specifications: t.specifications,
//                seller: t.seller)[0].name, t.expectedOutput[0].name)
//            XCTAssertEqual(allItems(
//                t.fromString,
//                dividersAndStringLocators: t.dividersAndStringLocators,
//                specifications: t.specifications,
//                seller: t.seller)[1].name, t.expectedOutput[1].name)
//            XCTAssertEqual(allItems(
//                t.fromString,
//                dividersAndStringLocators: t.dividersAndStringLocators,
//                specifications: t.specifications,
//                seller: t.seller)[0].originalPrice, t.expectedOutput[0].originalPrice)
//            XCTAssertEqual(allItems(
//                t.fromString,
//                dividersAndStringLocators: t.dividersAndStringLocators,
//                specifications: t.specifications,
//                seller: t.seller)[1].originalPrice, t.expectedOutput[1].originalPrice)
//            XCTAssertEqual(allItems(
//                t.fromString,
//                dividersAndStringLocators: t.dividersAndStringLocators,
//                specifications: t.specifications,
//                seller: t.seller)[0].salePrice, t.expectedOutput[0].salePrice)
//            XCTAssertEqual(allItems(
//                t.fromString,
//                dividersAndStringLocators: t.dividersAndStringLocators,
//                specifications: t.specifications,
//                seller: t.seller)[1].salePrice, t.expectedOutput[1].salePrice)
//            print("TEST_NAME: " + t.testName + " *** END")
//        }
//    }
//    
//    func testItem() {
//        struct Tests {
//            let testName: String
//            let fromString: String
//            let dividersAndStringLocators: [(String, (String, String)?)]
//            let specifications: [String: String]
//            let seller: String
//            let expectedOutput: Item?
//        }
//        let toTests = [
//            Tests(
//                testName: "item *** found",
//                fromString: loadHTMLFromBundle(Html1Item),
//                dividersAndStringLocators: [(footlockerShoeNamePoint,
//                    (footlockerShoeNameStart, footlockerShoeNameEnd)),
//                    (footlockerShoeOriginalPricePoint, nil), (footlockerShoeSalePricePoint, nil)],
//                specifications: ["size": "9.5"],
//                seller: "footlocker",
//                expectedOutput: Item(
//                    name: "Nike LeBron Zoom Soldier IX  - Men's - Blue / White",
//                    originalPrice: "167.00",
//                    salePrice: "139.99",
//                    specifications: ["size": "9.5"],
//                    seller: "footlocker"))
//        ]
//        for t in toTests {
//            print("TEST_NAME: " + t.testName + " *** START")
//            XCTAssertEqual(item(
//                t.fromString,
//                dividersAndStringLocators: t.dividersAndStringLocators,
//                specifications: t.specifications,
//                seller: t.seller).0?.name, t.expectedOutput?.name)
//            XCTAssertEqual(item(
//                t.fromString,
//                dividersAndStringLocators: t.dividersAndStringLocators,
//                specifications: t.specifications,
//                seller: t.seller).0?.originalPrice, t.expectedOutput?.originalPrice)
//            XCTAssertEqual(item(
//                t.fromString,
//                dividersAndStringLocators: t.dividersAndStringLocators,
//                specifications: t.specifications,
//                seller: t.seller).0?.salePrice, t.expectedOutput?.salePrice)
//            XCTAssertEqual((item(
//                t.fromString,
//                dividersAndStringLocators: t.dividersAndStringLocators,
//                specifications: t.specifications,
//                seller: t.seller).0?.specifications)!, (t.expectedOutput?.specifications)!)
//            XCTAssertEqual(item(
//                t.fromString,
//                dividersAndStringLocators: t.dividersAndStringLocators,
//                specifications: t.specifications,
//                seller: t.seller).0?.seller, t.expectedOutput?.seller)
//            print("TEST_NAME: " + t.testName + " *** END")
//        }
//    }
//    
//    
//    
//    
//    
//    
//    
//    
    
    
    
}