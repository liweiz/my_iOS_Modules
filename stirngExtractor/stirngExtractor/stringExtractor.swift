//
//  stringExtractor.swift
//  stirngExtractor
//
//  Created by Liwei Zhang on 2016-03-02.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

extension String {
    func stirngWithoutHeadTailWhitespaceBetween(start: String, end: String) -> String? {
        let splitByStart = split(start)
        if let tail = splitByStart.tailingString {
            if let head = tail.split(end).headingString {
                return head.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
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
    
    // findNumber returns the first number found in Float. The number has to start with with digits in 0...9.
    func findNumber() -> Float? {
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
        var result = Float(0)
        let n = Float(numericalDigits.count)
        if n > 0 {
            for d in numericalDigits {
                result += Float(d)! * powf(10, n - Float(numericalDigits.indexOf(d)! + 1))
            }
            for d in decimalDigits {
                result += Float(d)! * powf(10, -Float(decimalDigits.indexOf(d)! + 1))
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
    
    func numberInMiddle(start: String, end: String) -> Float? {
        return stirngWithoutHeadTailWhitespaceBetween(start, end: end)?.findNumber()
    }
//    func findNumbers(numbersFound: [Float]) -> [Float] {
//        if
//    }
}
