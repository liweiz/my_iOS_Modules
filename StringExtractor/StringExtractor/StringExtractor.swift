//
//  StringExtractor.swift
//  StirngExtractor
//
//  Created by Liwei Zhang on 2016-03-02.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

struct Item {
    var name: String = ""
    var originalPrice: String = ""
    var salePrice: String = ""
    var specifications: [String: String] = [String: String]()
    var seller: String = ""
    var discount: Float? {
        guard let up = Float(salePrice) else {
            return nil
        }
        guard let down = Float(originalPrice) else {
            return nil
        }
        return up * down == 0 ? nil : up / down
    }
}

// allItems return all items found in a string.
func allItems(fromString: String, dividersAndStringLocators: [(String, (String, String)?)], specifications: [String: String], seller: String) -> [Item] {
    return item(fromString, dividersAndStringLocators: dividersAndStringLocators, specifications: specifications, seller: seller, existingItems: [Item]())
}

func item(fromString: String, dividersAndStringLocators: [(String, (String, String)?)], specifications: [String: String], seller: String, existingItems: [Item]) -> [Item] {
    let itemFound = item(fromString, dividersAndStringLocators: dividersAndStringLocators, specifications: specifications, seller: seller)
    if let i = itemFound.0 {
        let items = existingItems + [i]
        if let s = itemFound.1 {
            if s != "" {
                return item(s, dividersAndStringLocators: dividersAndStringLocators, specifications: specifications, seller: seller, existingItems: items)
            }
        }
        return items
    }
    print(existingItems)
    return existingItems
}

// item return the first item fully found in the string and the last string left for further process. If there is absolute nothing (dividersAndStringLocators return all nil or name's counterpart not found) can be found or no more string to dig ("" returned as the string), return the string part of return value as nil. If only part of the item can be found, return a nil Item and the string after the name divider.
func item(fromString: String, dividersAndStringLocators: [(String, (String, String)?)], specifications: [String: String], seller: String) -> (Item?, String?) {
    print("called")
    if dividersAndStringLocators.count > 0 {
        var item = Item()
        var numberA: NumberInDigits? = nil
        var numberB: NumberInDigits? = nil
        let dividers = dividersAndStringLocators.map { $0.0 }
        let locators = dividersAndStringLocators.map { $0.1 }
        let strings = dividers.strings(fromString)
        var stringLeft: String?
        if strings.first! != nil {
            stringLeft = [dividers.first!].strings(fromString).last!
        }
        var i = 0
        for aString in strings {
            guard let s = aString else {
                return (nil, nil)
            }
//            print("HTML Divided: " + s)
            if let aLocator = locators[i] {
                guard let name = s.stirngWithoutHeadTailWhitespaceBetween(aLocator.0, end: aLocator.1) else {
                    return (nil, stringLeft)
                }
                item.name = name
            } else {
                guard let n = s.findNumber() else {
                    return (nil, stringLeft)
                }
//                print(n)
                numberA == nil ? (numberA = n) : (numberB = n)
            }
            i += 1
        }
        item.seller = seller
        item.specifications = specifications
        if numberA!.float! == max(numberA!.float!, numberB!.float!) {
            item.originalPrice = (numberA?.string)!
            item.salePrice = (numberB?.string)!
        } else {
            item.originalPrice = (numberB?.string)!
            item.salePrice = (numberA?.string)!
        }
        return (item, stringLeft)
    }
    return (nil, nil)
}

extension String {
    enum StringError: ErrorType {
        case String
    }
    func numberInMiddle(start: String, end: String) -> NumberInDigits? {
        return stirngWithoutHeadTailWhitespaceBetween(start, end: end)?.findNumber()
    }
    
    // stirngWithoutHeadTailWhitespaceBetween returns the Whitespace-trimmed string between two strings. It returns nil if start and end are not found.
    func stirngWithoutHeadTailWhitespaceBetween(start: String, end: String) -> String? {
        guard let splitByStart = split(start) else {
            return nil
        }
        guard let splitByEnd = splitByStart.tailingString.split(end) else {
            return nil
        }
        return splitByEnd.headingString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    // split splits the string into max 3 parts: the heading part, the string that is used to split and the tailing part. It returns nil if byString is not found.
    func split(byString: String) -> (headingString: String, tailingString: String)? {
        if let range = rangeOfString(byString) {
            return (self[startIndex..<range.startIndex], self[range.endIndex..<endIndex])
        }
        return nil
    }
    // stringBetween returns the string between two strings. It returns nil if any of the end strings can not be found.
    func stringBetween(start: String, end: String) -> String? {
        guard let startRange = rangeOfString(start) else {
            return nil
        }
        guard let endRange = rangeOfString(end) else {
            return nil
        }
        return startRange.endIndex <= endRange.startIndex ? self[startRange.endIndex..<endRange.startIndex] : ""
    }
    // findRange gets Range for a string and returns the Range follows. It returns nil, if no such substring found. It returns self.endIndex..<self.endIndex if there is no string left.
    func findRange(forString: String) -> Range<String.Index>? {
        if let rangeFound = rangeOfString(forString) {
            return rangeFound.endIndex..<endIndex
        }
        return nil
    }
    // findNumber returns the first number found in TBD. The number has to start with with digits in 0...9.
    func findNumber() -> NumberInDigits? {
        let numberCharacters: Set = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        let decimalMark = ","
        var numericalDigits = [String]()
        var decimalDigits = [String]()
        var stopChecking = false
        for c in characters {
            if stopChecking {
                break
            }
            let i = characters.indexOf(c)!
            let characterStringNow = self[i..<i.advancedBy(1)]
            if numberCharacters.contains(characterStringNow) {
                stopChecking = true
                var decimalPointMet = false
                var lastCharacterIsDecimalPoint = false
                for n in i..<endIndex {
                    let characterStringToExam = self[n..<n.advancedBy(1)]
                    if decimalPointMet {
                        if numberCharacters.contains(characterStringToExam) {
                            decimalDigits.append(characterStringToExam)
                        } else {
                            break
                        }
                    } else {
                        if lastCharacterIsDecimalPoint {
                            if numberCharacters.contains(characterStringToExam) {
                                numericalDigits.append(characterStringToExam)
                                lastCharacterIsDecimalPoint = false
                            } else {
                                break
                            }
                        } else {
                            if characterStringToExam == decimalMark {
                                lastCharacterIsDecimalPoint = true
                            } else if characterStringToExam == "." {
                                decimalPointMet = true
                            } else if numberCharacters.contains(characterStringToExam) {
                                numericalDigits.append(characterStringToExam)
                            } else {
                                break
                            }
                        }
                    }
                }
            }
        }
        return numericalDigits.count > 0 ? NumberInDigits(numericalDigits: numericalDigits, decimalDigits: decimalDigits) : nil
    }
}

// NumberInDigits stores all digits in a number as strings.
struct NumberInDigits {
    let numericalDigits: [String]
    let decimalDigits: [String]
    var isValid: Bool {
        return numericalDigits.count > 0 ? true : false
    }
    var string: String {
        var i = 0
        for n in numericalDigits {
            if n == "0" {
                i += 1
            } else {
                break
            }
        }
        var num = [String]()
        i > 0 ? num.appendContentsOf(numericalDigits.dropFirst(i)) : num.appendContentsOf(numericalDigits)
        let s = num.reduce("", combine: { $0 + $1 })
        return decimalDigits.count > 0 ? decimalDigits.reduce(s + ".", combine: { $0 + $1 }) : (s == "" ? "0" : s)
    }
    var float: Float? {
        var result = Float(0)
        let n = Float(numericalDigits.count)
        if n > 0 {
            var i  = 1
            for d in numericalDigits {
                result += Float(d)! * powf(10, n - Float(i))
                i += 1
            }
            var j  = 1
            for d in decimalDigits {
                result += Float(d)! * powf(0.1, Float(j))
                j += 1
            }
//            print("result: ", result)
            return result
        }
        return nil
    }
}

//Assuming the text to work on is composed of same tree-structured components.
//Each text anchor marking the start of a component is also the end of last component.
//An Array<String> can be used here as the structure for one layer of the tree structure.
extension SequenceType where Generator.Element == String {
    // allStrings uses the String SequenceType as marks to find out all strings from a string. It returns the content strings as [String?]. Nil is for content not found.
    func allStrings(fromString: String) -> [String?] {
        var stringLeft = fromString
        var results = [String?]()
        var nilStringArray = [String?]()
        for mark in self {
            if let splitStrings = stringLeft.split(mark) {
                results.append(splitStrings.headingString)
                if nilStringArray.count > 0 {
                    results.appendContentsOf(nilStringArray)
                    nilStringArray.removeAll()
                }
                stringLeft = splitStrings.tailingString
            } else {
                nilStringArray.append(nil)
            }
        }
        if (results.filter { $0 != nil }).count == 0 {
            results = nilStringArray
        } else {
            if results.count > 0 { results.append(stringLeft) }
        }
        if results.count > self.underestimateCount() { results.removeFirst() }
        return results
    }
}