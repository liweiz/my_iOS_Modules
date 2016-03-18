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
    
    let testHead = "TEST_NAME "
    let testStartNotice = " *** START"
    let testFuncReturn_0 = " * Return.0"
    let testFuncReturn_1 = " * Return.1"
    let testEndNotice = " *** END"
    
    func printStart(testFuncName: String, testName: String, testIndex: Int) {
        print(testHead + "\(i): " + testFuncName + " *** " + testName +testStartNotice)
    }
    func printFuncReturn_0(testName: String, testIndex: Int) {
        print(testHead + "\(i): " + testFuncName + " *** " + testName +testFuncReturn_0)
    }
    func printFuncReturn_1(testName: String, testIndex: Int) {
        print(testHead + "\(i): " + testFuncName + " *** " + testName +testFuncReturn_1)
    }
    func printEnd(testName: String, testIndex: Int) {
        print(testHead + "\(i): " + testFuncName + " *** " + testName +testEndNotice)
    }
    
    
    
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
                testName: "allItem *** found",
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
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            XCTAssertEqual(allItems(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller)[0].name, t.expectedOutput[0].name)
            XCTAssertEqual(allItems(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller)[1].name, t.expectedOutput[1].name)
            XCTAssertEqual(allItems(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller)[0].originalPrice, t.expectedOutput[0].originalPrice)
            XCTAssertEqual(allItems(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller)[1].originalPrice, t.expectedOutput[1].originalPrice)
            XCTAssertEqual(allItems(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller)[0].salePrice, t.expectedOutput[0].salePrice)
            XCTAssertEqual(allItems(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller)[1].salePrice, t.expectedOutput[1].salePrice)
            print("TEST_NAME: " + t.testName + " *** END")
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
                testName: "item *** found",
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
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            XCTAssertEqual(item(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller).0?.name, t.expectedOutput?.name)
            XCTAssertEqual(item(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller).0?.originalPrice, t.expectedOutput?.originalPrice)
            XCTAssertEqual(item(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller).0?.salePrice, t.expectedOutput?.salePrice)
            XCTAssertEqual((item(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller).0?.specifications)!, (t.expectedOutput?.specifications)!)
            XCTAssertEqual(item(
                t.fromString,
                dividersAndStringLocators: t.dividersAndStringLocators,
                specifications: t.specifications,
                seller: t.seller).0?.seller, t.expectedOutput?.seller)
            print("TEST_NAME: " + t.testName + " *** END")
        }
    }
    
    func testFindRange() {
        struct Tests {
            let testName: String
            let input: String
            let expectedOutput: Range<String.Index>?
        }
        let stringToTest = "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is."
        let toTests = [
            Tests(testName: "findRange *** found with range does not reach end", input: "like", expectedOutput: stringToTest.startIndex.advancedBy(6)..<stringToTest.endIndex),
            Tests(testName: "findRange *** found with range reaches end", input: "assertion is.", expectedOutput: stringToTest.endIndex..<stringToTest.endIndex),
            Tests(testName: "findRange *** not found", input: "assertiof", expectedOutput: nil)
        ]
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            XCTAssertEqual(stringToTest.findRange(t.input), t.expectedOutput)
            print("TEST_NAME: " + t.testName + " *** END")
        }
    }
    
    func testSplit() {
        struct Tests {
            let testName: String
            let input: String
            let expectedOutput: (String, String)?
        }
        let stringToTest = "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is."
        let toTests = [
            Tests(testName: "splitted with both head and tail", input: "like", expectedOutput: ("I ", " to name my Test Case so it is obvious to see what method is being called and what the assertion is.")),
            Tests(testName: "splitted with head only", input: "assertion is.", expectedOutput: ("I like to name my Test Case so it is obvious to see what method is being called and what the ", "")),
            Tests(testName: "splitted with tail only", input: "I like ", expectedOutput: ("", "to name my Test Case so it is obvious to see what method is being called and what the assertion is.")),
            Tests(testName: "splitted with empty on both sides", input: "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ("", "")),
            Tests(testName: "splitted with split string not found", input: "dds", expectedOutput: nil)
        ]
        let testTargetName = "split *** "
        for t in toTests {
            print(testHead + t.testName + " *** START")
            print(testHead + t.testName + " * Return.0")
            XCTAssertEqual(stringToTest.split(t.input).headingString, t.expectedOutput.0)
            print(testHead + t.testName + " * Return.1")
            XCTAssertEqual(stringToTest.split(t.input).tailingString, t.expectedOutput.1)
            print(testHead + t.testName + " *** END")
        }
    }
    
    func testStirngWithoutHeadTailWhitespaceBetween() {
        struct Tests {
            let testName: String
            let input0: String
            let input1: String
            let expectedOutput: String?
        }
        let stringToTest = "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is."
        let toTests = [
            Tests(testName: "stirngWithoutHeadTailWhitespaceBetween *** both are in the middle", input0: "like", input1: "is", expectedOutput: "to name my Test Case so it"),
            Tests(testName: "stirngWithoutHeadTailWhitespaceBetween *** both are at the ends", input0: "I", input1: ".", expectedOutput: "like to name my Test Case so it is obvious to see what method is being called and what the assertion is"),
            Tests(testName: "stirngWithoutHeadTailWhitespaceBetween *** one not found", input0: "cool", input1: "like", expectedOutput: nil),
            ]
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            XCTAssertEqual(stringToTest.stirngWithoutHeadTailWhitespaceBetween(t.input0, end: t.input1), t.expectedOutput)
            print("TEST_NAME: " + t.testName + " *** END")
        }
    }
    
    func testStringBetween() {
        struct Tests {
            let testName: String
            let input0: String
            let input1: String
            let expectedOutput: String?
        }
        let stringToTest = "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is."
        let toTests = [
            Tests(testName: "stringBetween *** both are in the middle", input0: "like", input1: "is", expectedOutput: " to name my Test Case so it "),
            Tests(testName: "stringBetween *** both are at the ends", input0: "I", input1: ".", expectedOutput: " like to name my Test Case so it is obvious to see what method is being called and what the assertion is"),
            Tests(testName: "stringBetween *** one not found", input0: "cool", input1: "like", expectedOutput: nil),
            ]
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            XCTAssertEqual(stringToTest.stringBetween(t.input0, end: t.input1), t.expectedOutput)
            print("TEST_NAME: " + t.testName + " *** END")
        }
    }
    
    func testFindNumber() {
        struct Tests {
            let testName: String
            let stringToTest: String
            let expectedOutput: String?
        }
        let toTests = [
            Tests(testName: "findNumber *** $139.99</B></em><BR></p>", stringToTest: " $139.99</B></em><BR></p>", expectedOutput: "139.99"),
            Tests(testName: "findNumber *** numerical digits only", stringToTest: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1342"),
            Tests(testName: "findNumber *** with decimal digits", stringToTest: "I like to name my 1342.1 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1342.1"),
            Tests(testName: "findNumber *** beginning with multiple 0s", stringToTest: "I like to name my 0001342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1342"),
            Tests(testName: "findNumber *** beginning with multiple 0s with decimal mark", stringToTest: "I like to name my 0,001,342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1342"),
            Tests(testName: "findNumber *** beginning with multiple 0s with continuous decimal marks", stringToTest: "I like to name my 0,,001,342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "0"),
            Tests(testName: "findNumber *** beginning with multiple 0s with decimal marks following decimal point", stringToTest: "I like to name my 0,001.,342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1"),
            Tests(testName: "findNumber *** beginning with multiple 0s with decimal marks after decimal point", stringToTest: "I like to name my 0,001.3,4,2 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1.3"),
            Tests(testName: "findNumber *** beginning with multiple 0s with decimal point following decimal mark", stringToTest: "I like to name my 0,001,.342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1"),
            Tests(testName: "findNumber *** no number", stringToTest: "I like to name my Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: nil),
            Tests(testName: "findNumber *** beginning with multiple 0s with continuous decimal points", stringToTest: "I like to name my 0,001..342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "1"),
            Tests(testName: "findNumber *** beginning with decimal point", stringToTest: "I like to name my ..342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: "342")
        ]
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            XCTAssertEqual(t.stringToTest.findNumber()?.string, t.expectedOutput)
            print("TEST_NAME: " + t.testName + " *** END")
        }
    }
    
    func testStrings() {
        struct Tests {
            let testName: String
            let stringArrayToTest: [String]
            let input: String
            let expectedOutput: [String?]
        }
        let toTests = [
            Tests(testName: "strings *** all found with non-empty results", stringArrayToTest: [" ", "to", "my", "so"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ["like ", " name ", " 1342 Test Case ", " it is obvious to see what method is being called and what the assertion is."]),
            Tests(testName: "strings *** all found with some empty results", stringArrayToTest: [" ", "to", "my", "so", "."], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ["like ", " name ", " 1342 Test Case ", " it is obvious to see what method is being called and what the assertion is", ""]),
            Tests(testName: "strings *** all found with some nil results", stringArrayToTest: [" ", "goo", "my", "so"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ["like to name ", nil, " 1342 Test Case ", " it is obvious to see what method is being called and what the assertion is."]),
            Tests(testName: "strings *** all found except the first one", stringArrayToTest: ["  ", "to", "my", "so", "."], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: [nil, " name ", " 1342 Test Case ", " it is obvious to see what method is being called and what the assertion is", ""]),
            Tests(testName: "strings *** all not found except the last one", stringArrayToTest: ["  ", "goo", "myd", "so"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: [nil, nil, nil, " it is obvious to see what method is being called and what the assertion is."]),
            Tests(testName: "strings *** all not found except the first and last one", stringArrayToTest: [" ", "goo", "myd", "so"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: ["like to name my 1342 Test Case ", nil, nil, " it is obvious to see what method is being called and what the assertion is."]),
            Tests(testName: "strings *** all not found", stringArrayToTest: ["  ", "goo", "myd", "soe"], input: "I like to name my 1342 Test Case so it is obvious to see what method is being called and what the assertion is.", expectedOutput: [nil, nil, nil, nil]),
            ]
        for t in toTests {
            print("TEST_NAME: " + t.testName + " *** START")
            for i in 0..<t.expectedOutput.count {
                XCTAssertEqual(t.stringArrayToTest.strings(t.input)[i], t.expectedOutput[i])
            }
            print("TEST_NAME: " + t.testName + " *** END")
        }
    }
    
    // From https://www.hackingwithswift.com/example-code/strings/how-to-load-a-string-from-a-file-in-your-bundle
    func loadHTMLFromBundle(fileName: String) -> String {
        if let filepath = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt") {
            do {
                let contents = try NSString(contentsOfFile: filepath, usedEncoding: nil) as String
//                print(contents)
                return contents
                //            return content
            } catch {
                // contents could not be loaded
                print("contents could not be loaded")
            }
        } else {
            // example.txt not found!
            print("html could not be loaded")
        }
        return ""
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}