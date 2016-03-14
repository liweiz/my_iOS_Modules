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
    dynamic var shownBefore: Bool = false
    
    func setupAlreadyInDb(db: Realm) {
        alreadyInDb = sameItemFound(seller, name: name, specifications: specifications) ? true : false
    }
}

func itemsFromDb(db: Realm) -> [String: [ItemOnSale]] {
    var r = [String: [ItemOnSale]]()
    let items = db.objects(ItemOnSale)
    let sellers = Set(items.map { $0.seller })
    for s in sellers {
        let condition = "seller = '" + s + "'"
        var i = [ItemOnSale]()
        items.filter(condition).forEach { i.append($0) }
        r[s] = i
    }
    return r
}