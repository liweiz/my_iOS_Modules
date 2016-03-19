//
//  StringTest.swift
//  StringTest
//
//  Created by Liwei Zhang on 2016-03-17.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

extension String {
    func stirngWithoutHeadTailWhitespaceBetween(start: String, end: String) -> String? {
        guard let splitByStart = split(start) else {
            return nil
        }
        guard let splitByEnd = splitByStart.tailingString.split(end) else {
            return nil
        }
        return splitByEnd.headingString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    // split splits the string into max 3 parts: the heading part, the string that is used to split and the tailing part.
    func split(byString: String) -> (headingString: String, tailingString: String)? {
        if let range = rangeOfString(byString) {
            return (self[startIndex..<range.startIndex], self[range.endIndex..<endIndex])
        }
        return nil
    }
    func stringBetween(start: String, end: String) -> String? {
        guard let startRange = rangeOfString(start) else {
            return nil
        }
        guard let endRange = rangeOfString(end) else {
            return nil
        }
        return startRange.endIndex <= endRange.startIndex ? self[startRange.endIndex..<endRange.startIndex] : ""
    }
    func findRange(forString: String) -> Range<String.Index>? {
        if let rangeFound = rangeOfString(forString) {
            return rangeFound.endIndex..<endIndex
        }
        return nil
    }

}



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