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
