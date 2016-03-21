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
    i.specifications = specificationsInOneString(item.specifications)
    i.discount = item.discount ?? 0
    i.timestamp = NSDate().timeIntervalSince1970
    i.category = i.seller + " " + i.specifications
    return i
}

func specificationsInOneString(specifications: [String : String]) -> String {
    var s = ""
    var n = 1
    for k in specifications.keys {
        if k != "" && specifications[k] != nil {
            s.appendContentsOf(k)
            s.appendContentsOf(": ")
            s.appendContentsOf(specifications[k]!)
            if n == specifications.keys.count {
                s.appendContentsOf(".")
            } else {
                s.appendContentsOf(", ")
            }
        }
        n += 1
    }
    return s
}

func clearAllItems(forCategory: String) {
    for i in findItems(forCategory) {
        try! realm.write {
            realm.delete(i)
        }
    }
}

func findItems(forCategory: String) -> Results<ItemOnSale> {
    let condition = "category = '" + forCategory + "'"
    return realm.objects(ItemOnSale).filter(condition)
}

func sameItemFound(fromSeller: String, name: String, specifications: String) -> Bool {
    let predicate = NSPredicate(format: "seller = %@ AND name = %@ AND specifications = %@", fromSeller, name, specifications)
    return realm.objects(ItemOnSale).filter(predicate).count > 0 ? true : false
}
