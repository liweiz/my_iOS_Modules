//
//  Models.swift
//  SaleWatcher
//
//  Created by Liwei Zhang on 2016-03-11.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class ItemOnSale: Object {
    dynamic var name: String = ""
    dynamic var seller: String = ""
    dynamic var originalPrice: String = ""
    dynamic var salePrice: String = ""
    dynamic var discount: Float = 0
    dynamic var specifications: String = ""
    dynamic var timestamp: Double = 0
//    dynamic var alreadyInDb: Bool = false
    dynamic var shownBefore: Bool = false
    dynamic var category: String = ""
//    func setupAlreadyInDb(db: Realm) {
//        alreadyInDb = sameItemFound(seller, name: name, specifications: specifications) ? true : false
//    }
    func setupShownBefore(db: Realm) {
        let predicate = NSPredicate(format: "seller = %@ AND name = %@ AND specifications = %@ AND shownBefore = %@", seller, name, specifications, true)
        if db.objects(ItemOnSale).filter(predicate).count > 0 {
            shownBefore = true
        }
    }
}

func itemsFromDb(db: Realm) -> [String: [ItemOnSale]] {
    var r = [String: [ItemOnSale]]()
    let items = db.objects(ItemOnSale)
    let categories = Set(items.map { $0.category })
    for c in categories {
        let condition = "category = '" + c + "'"
        var i = [ItemOnSale]()
        items.filter(condition).forEach { i.append($0) }
        r[c] = i
    }
    // BUG here, should not remove all all existing items every time.
    
    
    UIApplication.sharedApplication().applicationIconBadgeNumber = items.filter { $0.shownBefore == false }.count
    return r
}

func markAllAsShown(db: Realm) {
    db.objects(ItemOnSale).forEach {x in
        try! db.write {
            x.shownBefore = true
        }
    }
}

func markAsShown(db: Realm, obj: ItemOnSale) {
    try! db.write {
        obj.shownBefore = true
    }
}