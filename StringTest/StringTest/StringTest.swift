//
//  StringTest.swift
//  StringTest
//
//  Created by Liwei Zhang on 2016-03-17.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation

extension String {
    // split splits the string into max 3 parts: the heading part, the string that is used to split and the tailing part.
    func split(byString: String) -> (headingString: String, tailingString: String)? {
        if let range = rangeOfString(byString) {
            return (self[startIndex..<range.startIndex], self[range.endIndex..<endIndex])
        }
        return nil
    }
    

}
