//
//  NumberInDigits.swift
//  StringExtractor
//
//  Created by Liwei Zhang on 2016-03-19.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

extension String {
    /// numberInMiddle returns the first occurance of number.
    func numberInMiddle(start: String, end: String) -> NumberInDigits? {
        return stirngWithoutHeadTailWhitespaceBetween(start, end: end)?.findNumber()
    }
    /// findNumber returns the first number found in self. The number has to start with with digits in 0...9.
    func findNumber() -> NumberInDigits? {
        let numberCharacters: Set = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
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
        let digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return numericalDigits.count > 0 ? NumberInDigits(numericalDigitIndice: numericalDigits.map { digits.indexOf($0)! }, decimalDigitIndice: decimalDigits.map { digits.indexOf($0)! }) : nil
    }
}

/// NumberInDigits stores all digits of a number as strings.
struct NumberInDigits {
    let digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let numericalDigitIndice: [Int]
    let decimalDigitIndice: [Int]
    /// isEmpty returns false when no actual digit is stored.
    var isEmpty: Bool {
        return numericalDigitIndice.count + decimalDigitIndice.count > 0 ? false : true
    }
    /// string returns the number in form of String.
    var string: String {
        var i = 0
        for index in numericalDigitIndice {
            if digits[index] == "0" {
                i += 1
            } else {
                break
            }
        }
        var numString = (numericalDigitIndice.dropFirst(i).map { digits[$0] }).reduce("", combine: { $0 + $1 })
        if numString == "" { numString = "0" }
        return decimalDigitIndice.count > 0 ? (decimalDigitIndice.map { digits[$0] }).reduce(numString + ".", combine: { $0 + $1 }) : numString
    }
    /// float returns the number in form of Float.
    var float: Float {
        var result = Float(0)
        let n = Float(numericalDigitIndice.count)
        if n > 0 {
            var i  = 1
            for d in (numericalDigitIndice.map { digits[$0] }) {
                result += Float(d)! * powf(10, n - Float(i))
                i += 1
            }
            var j  = 1
            for d in (decimalDigitIndice.map { digits[$0] }) {
                result += Float(d)! * powf(0.1, Float(j))
                j += 1
            }
        }
        return result
    }
}