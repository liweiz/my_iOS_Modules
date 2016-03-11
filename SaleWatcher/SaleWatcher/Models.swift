//
//  Models.swift
//  SaleWatcher
//
//  Created by Liwei Zhang on 2016-03-11.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import RealmSwift

class ItemOnSale: Object {
    dynamic var name: String = ""
    dynamic var seller: String = ""
    dynamic var originalPrice: String = ""
    dynamic var salePrice: String = ""
    dynamic var discount: Float = 0
    dynamic var specifications: String = ""
    dynamic var timestamp: Double = 0
    dynamic var alreadyInDb: Bool = false
}
