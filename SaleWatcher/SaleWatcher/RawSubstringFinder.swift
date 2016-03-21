//
//  RawSubstringFinder.swift
//  StringExtractor
//
//  Created by Liwei Zhang on 2016-03-19.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

extension String {
    /// stirngWithoutHeadTailWhitespaceBetween returns the Whitespace-trimmed string between two strings. It returns nil if start and end are not found.
    func stirngWithoutHeadTailWhitespaceBetween(start: String, end: String) -> String? {
        guard let splitByStart = split(start) else {
            return nil
        }
        guard let splitByEnd = splitByStart.tailingString.split(end) else {
            return nil
        }
        return splitByEnd.headingString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    /// split splits the string into max 3 parts: the heading part, the string that is used to split and the tailing part. It returns nil if byString is not found.
    func split(byString: String) -> (headingString: String, tailingString: String)? {
        if let range = rangeOfString(byString) {
            return (self[startIndex..<range.startIndex], self[range.endIndex..<endIndex])
        }
        return nil
    }
    /// stringBetween returns the string between two strings. It returns nil if any of the end strings can not be found.
    func stringBetween(start: String, end: String) -> String? {
        guard let startRange = rangeOfString(start) else {
            return nil
        }
        guard let endRange = rangeOfString(end) else {
            return nil
        }
        return startRange.endIndex <= endRange.startIndex ? self[startRange.endIndex..<endRange.startIndex] : ""
    }
    /// findRange gets Range for a string and returns the Range follows. It returns nil, if no such substring found. It returns self.endIndex..<self.endIndex if there is no string left.
    func findRange(forString: String) -> Range<String.Index>? {
        if let rangeFound = rangeOfString(forString) {
            return rangeFound.endIndex..<endIndex
        }
        return nil
    }
}

//Assuming the text to work on is composed of same tree-structured components.
//Each text anchor marking the start of a component is also the end of last component.
//An Array<String> can be used here as the structure for one layer of the tree structure.
extension SequenceType where Generator.Element == String {
    /// substrings uses the String SequenceType as marks to find out the first occurance of a set of substrings from a string. It returns the content strings as [String?]. Nil is for content not found.
    func substrings(fromString: String) -> [String?] {
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