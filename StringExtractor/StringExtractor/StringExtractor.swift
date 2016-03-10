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
    var size: String = ""
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

enum ItemSearchError: ErrorType {
    case NumberNotFound
    case StringNotFound
    case NoItem
}

func allItems(fromString: String, dividersAndStringLocators: [(String, (String, String)?)], size: String, seller: String) -> [Item] {
    return item(fromString, dividersAndStringLocators: dividersAndStringLocators, size: size, seller: seller, existingItems: [Item]())
}

func item(fromString: String, dividersAndStringLocators: [(String, (String, String)?)], size: String, seller: String, existingItems: [Item]) -> [Item] {
    let itemFound = item(fromString, dividersAndStringLocators: dividersAndStringLocators, size: size, seller: seller)
    if let i = itemFound.0 {
        let items = existingItems + [i]
        if let s = itemFound.1 {
            if s != "" {
                return item(s, dividersAndStringLocators: dividersAndStringLocators, size: size, seller: seller, existingItems: items)
            }
        }
        return items
    }
    print(existingItems)
    return existingItems
}

// item return the first item fully found in the string and the last string left for further process. If there is absolute nothing (dividersAndStringLocators return all nil or name's counterpart not found) can be found or no more string to dig ("" returned as the string), return the string part of return value as nil. If only part of the item can be found, return a nil Item and the string after the name divider.
func item(fromString: String, dividersAndStringLocators: [(String, (String, String)?)], size: String, seller: String) -> (Item?, String?) {
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
        item.size = size
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
    func numberInMiddle(start: String, end: String) -> NumberInDigits? {
        return stirngWithoutHeadTailWhitespaceBetween(start, end: end)?.findNumber()
    }
    func stirngWithoutHeadTailWhitespaceBetween(start: String, end: String) -> String? {
        let splitByStart = split(start)
        if let tail = splitByStart.tailingString {
            if let head = tail.split(end).headingString {
                return head.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
        }
        return nil
    }
    func stringBetween(start: String, end: String) -> String? {
        if let startRange = rangeOfString(start) {
            if let endRange = rangeOfString(end) {
                if startRange.endIndex <= endRange.startIndex {
                    return self[startRange.endIndex..<endRange.startIndex]
                }
            }
        }
        return nil
    }
    // findRange gets Range for a string and returns the Range follows. It returns nil, if no such substring found. It returns self.endIndex..<self.endIndex if there is no string left.
    func findRange(forString: String) -> Range<String.Index>? {
        if let rangeFound = rangeOfString(forString) {
            return rangeFound.endIndex..<endIndex
        }
        return nil
    }
    // split splits the string into max 3 parts: the heading part, the string that is used to split and the tailing part.
    func split(byString: String) -> (headingString: String?, tailingString: String?) {
        if let range = rangeOfString(byString) {
            return (self[startIndex..<range.startIndex], self[range.endIndex..<endIndex])
        }
        return (nil, nil)
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



/*
 Assuming the text we are working on is composed of same tree-structured components. Each text anchor that notifies the start of a component is also the end of last component. It is also applied to the sub-components in component that a component's start is the end of the last one.
 */
//An Array<String> can be used here to show the structure of one layer of the tree structure.
extension SequenceType where Generator.Element == String {
    func strings(fromString: String) -> [String?] {
        var stringLeft = fromString
        var r = [String?]()
        var nilStringArray = [String?]()
        for s in self {
            if let tail = stringLeft.split(s).tailingString {
                r.append(stringLeft.split(s).headingString!)
                if nilStringArray.count > 0 {
                    r.appendContentsOf(nilStringArray)
                    nilStringArray.removeAll()
                }
                stringLeft = tail
            } else {
                nilStringArray.append(nil)
            }
        }
        var allNil = true
        for x in r {
            if x != nil {
                allNil = false
                break
            }
        }
        if allNil {
            r = nilStringArray
        } else {
            if r.count > 0 { r.append(stringLeft) }
        }
        if r.count > self.underestimateCount() { r.removeFirst() }
        return r
    }
}