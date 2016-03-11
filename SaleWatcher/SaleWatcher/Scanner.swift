//
//  Scanner.swift
//  SaleWatcher
//
//  Created by Liwei Zhang on 2016-03-10.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import Alamofire

struct scanner {
    let url: String
    let seller: String
    let specifications: [String: String]
    var scanIntervalInSec: Int = 60 * 10
    
    func scan() ->  {
        Alamofire.request(.GET, url).responseString(completionHandler: {
            if $0.result.isSuccess {
                if let stringReturned = $0.result.value {
                    
                }
            }
            
        })
    }
}

