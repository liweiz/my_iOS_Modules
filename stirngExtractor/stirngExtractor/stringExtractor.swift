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
    
    // findNumber returns the first number found in Float. The number has to start with with digits in 0...9.
    func findNumber() -> Float? {
        let numberCharacters: Set = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        let decimalMark = ","
        var digitsBeforeDot = [String]()
        var digitsAfterDot = [String]()
        var stopChecking = false
        for c in characters {
            if stopChecking {
                break
            }
            let i = characters.indexOf(c)!
            let characterStringNow = self[i..<i.advancedBy(1)]
            if numberCharacters.contains(characterStringNow) {
                stopChecking = true
                var dotMet = false
                var lastCharacterIsDecimalMark = false
                for n in i..<endIndex {
                    let characterStringToExam = self[n..<n.advancedBy(1)]
                    if dotMet {
                        if numberCharacters.contains(characterStringToExam) {
                            digitsAfterDot.append()
                        } else {
                            break
                        }
                    } else {
                        if lastCharacterIsDecimalMark {
                            if numberCharacters.contains(characterStringToExam) {
                                digitsBeforeDot.append(characterStringToExam)
                                lastCharacterIsDecimalMark = false
                            } else {
                                break
                            }
                        } else {
                            if characterStringToExam == decimalMark {
                                lastCharacterIsDecimalMark = true
                            } else if characterStringToExam == "." {
                                dotMet = true
                            } else if numberCharacters.contains(characterStringToExam) {
                                digitsBeforeDot.append(characterStringToExam)
                            } else {
                                break
                            }
                        }
                    }
                }
            }
        }
        var result = float(0)
        let n = digitsBeforeDot.count
        if n > 0 {
            for d in digitsBeforeDot {
                result += float(d) * powf(10, n - float(digitsBeforeDot.indexOf(d) + 1))
            }
            for d in digitsAfterDot {
                result += float(d) * powf(10, -float(digitsAfterDot.indexOf(d) + 1))
            }
            return result
        }
        return nil
    }
    func stringInMiddle(start: String, end: String) -> String? {
        if let startRange = rangeOfString(start) {
            if let endRange = rangeOfString(end) {
                if startRange.endIndex <= endRange.startIndex {
                    return self[startRange.endIndex..<endRange.startIndex]
                }
            }
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
    func numberInMiddle(start: String, end: String) -> Float? {
        return stirngWithoutHeadTailWhitespaceBetween(start, end: end)?.findNumber()
    }
    func findNumbers(numbersFound: [Float]) -> [Float] {
        if
    }
}
