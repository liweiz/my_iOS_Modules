//
//  Item.swift
//  StringExtractor
//
//  Created by Liwei Zhang on 2016-03-19.
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
    return existingItems
}

// item return the first item fully found in the string and the last string left for further process. If there is absolute nothing (dividersAndStringLocators return all nil or the key string to identify an item not found) can be found or no more string to dig ("" returned as the string), return the string part of return value as nil. If only part of the item can be found, return a nil for Item and the string after the name divider.
func item(fromString: String, dividersAndStringLocators: [(String, (String, String)?)], specifications: [String: String], seller: String) -> (Item?, String?) {
    if dividersAndStringLocators.count > 0 {
        var item = Item()
        var numberA: NumberInDigits? = nil
        var numberB: NumberInDigits? = nil
        let dividers = dividersAndStringLocators.map { $0.0 }
        let locators = dividersAndStringLocators.map { $0.1 }
        let stringsFound = dividers.substrings(fromString)
        var stringLeft: String?
        guard let key = stringsFound.first else {
            return (nil, nil)
        }
        stringLeft = [dividers.first!].substrings(fromString).last!
        var i = 0
        for aString in stringsFound {
            guard let s = aString else {
                return (nil, nil)
            }
            if let aLocator = locators[i] {
                guard let name = s.stirngWithoutHeadTailWhitespaceBetween(aLocator.0, end: aLocator.1) else {
                    return (nil, stringLeft)
                }
                item.name = name
            } else {
                guard let n = s.findNumber() else {
                    return (nil, stringLeft)
                }
                numberA == nil ? (numberA = n) : (numberB = n)
            }
            i += 1
        }
        item.seller = seller
        item.specifications = specifications
        if numberA!.float == max(numberA!.float, numberB!.float) {
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