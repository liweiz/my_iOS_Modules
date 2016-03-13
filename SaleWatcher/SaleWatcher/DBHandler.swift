//
//  DBHandler.swift
//  SaleWatcher
//
//  Created by Liwei Zhang on 2016-03-12.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import RealmSwift

let realm = try! Realm()

func itemToModel(item: Item) -> ItemOnSale {
    let i = ItemOnSale()
    i.name = item.name
    i.originalPrice = item.originalPrice
    i.salePrice = item.salePrice
    i.seller = item.seller
    var s = ""
    var n = 1
    for k in item.specifications.keys {
        if k != "" && item.specifications[k] != nil {
            s.appendContentsOf(k)
            s.appendContentsOf(": ")
            s.appendContentsOf(item.specifications[k]!)
            if n == item.specifications.keys.count {
                s.appendContentsOf(".")
            } else {
                s.appendContentsOf(", ")
            }
        }
        n += 1
    }
    i.specifications = s
    i.discount = item.discount ?? 0
    i.timestamp = NSDate().timeIntervalSince1970
    return i
}

func clearAllItems(fromSeller: String) {
    for i in findItems(fromSeller) {
        try! realm.write {
            realm.delete(i)
        }
    }
}

func findItems(fromSeller: String) -> Results<ItemOnSale> {
    let condition = "seller = '" + fromSeller + "'"
    return realm.objects(ItemOnSale).filter(condition)
}

func sameItemFound(fromSeller: String, name: String, specifications: String) -> Bool {
    let predicate = NSPredicate(format: "seller = %@ AND name = %@ AND specifications = %@", fromSeller, name, specifications)
    return realm.objects(ItemOnSale).filter(predicate).count > 0 ? true : false
}
