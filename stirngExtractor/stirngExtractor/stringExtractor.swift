//
//  stringExtractor.swift
//  stirngExtractor
//
//  Created by Liwei Zhang on 2016-03-02.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

extension String {
    // findRange gets Range for a string and returns the Range follows. It returns nil, if no such substring found. It returns forString.endIndex..<forString.endIndex if there is no string left.
    func findRange(forString: String) -> Range<String.Index>? {
        if let rangeFound = rangeOfString(forString) {
            if rangeFound.endIndex == forString.endIndex {
                return forString.endIndex..<forString.endIndex
            }
            return rangeFound.endIndex..<forString.endIndex
        }
        return nil
    }
    // split splits the string into max 3 parts: the heading part, the string that is used to split and the tailing part.
    func split(byString: String) -> (headingString: String, tailingString: String)? {
        if let range = findRange(byString) {
            if range.startIndex == byString.startIndex && range.endIndex == byString.endIndex  {
                return nil
            } else if range.startIndex == byString.startIndex {
                return ("", self[range.endIndex..<byString.endIndex])
            } else if range.endIndex == byString.endIndex {
                return (self[byString.startIndex..<range.startIndex], "")
            }
            return (self[byString.startIndex..<range.startIndex], self[range.endIndex..<byString.endIndex])
        }
        return nil
    }
    func stirngWithoutHeadTailWhitespaceBetween(start: String, end: String) -> String? {
        if let splitByStart = split(start) {
            if splitByStart.tailingString != "" {
                if let splitByEnd = splitByStart.tailingString.split(end) {
                    if splitByEnd.headingString != "" {
                        return splitByEnd.headingString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    }
                }
            }
        }
        return nil
    }
    
    func extractPrice(start: String, end: String) -> CGFloat? {
        if let price = stirngWithoutHeadTailWhitespaceBetween(start, end) {
            
        }
    }
}
