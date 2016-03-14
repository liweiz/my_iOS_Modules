//
//  Scanner.swift
//  SaleWatcher
//
//  Created by Liwei Zhang on 2016-03-10.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

func scanAll() {
    scanner_FootLocker_men_95_performance_basketball_shoes().scan()
    scanner_Lego().scan()
    scanner_Nike_men_95_running_shoes().scan()
}

func scanner_Lego() -> scanner {
    let url = "http://shop.lego.com/en-CA/Sales-And-Deals"
    let namePoint = "Quick View" // Look for "title" follows.
    let originalPricePoint = "was-price"
    let salePricePoint = "now-price"
    
    let nameStart = "<a title=\""
    let nameEnd = "\" href=\""
    
    let dividersAndStringLocators: [(String, (String, String)?)] = [(namePoint, (nameStart, nameEnd)), (originalPricePoint, nil), (salePricePoint, nil)]
    return scanner(url: url, seller: "Lego", specifications: ["": ""], dividersAndStringLocators: dividersAndStringLocators)
}

func scanner_FootLocker_men_95_performance_basketball_shoes() -> scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Mens/Nike/Shoes/Performance-Basketball-Shoes/_-_/N-1z141w4Z24ZzzZrjZseZca"
    let namePoint = "quickviewEnabled" // Look for "title" follows.
    let originalPricePoint = "product_price"
    let salePricePoint = "<B>Now"
    
    let nameStart = "title=\""
    let nameEnd = "\" href="
    
    let dividersAndStringLocators: [(String, (String, String)?)] = [(namePoint, (nameStart, nameEnd)), (originalPricePoint, nil), (salePricePoint, nil)]
    return scanner(url: url, seller: "Foot Locker", specifications: ["size": "9.5"], dividersAndStringLocators: dividersAndStringLocators)
}

func scanner_Nike_men_95_running_shoes() -> scanner {
    let url = "http://store.nike.com/ca/en_gb/pw/mens-sale-running-shoes/47Z60wZ7puZ8yzZoi3"
    let namePoint = "grid-item-info" // Look for "title" follows.
    let originalPricePoint = "<span class=\"overridden nsg-font-family--base\">"
    let salePricePoint = "<span class=\"local nsg-font-family--base\">"
    
    let nameStart = "<p class=\"product-display-name nsg-font-family--base edf-font-size--regular nsg-text--dark-grey\" >"
    let nameEnd = "</p>"
    
    let dividersAndStringLocators: [(String, (String, String)?)] = [(namePoint, (nameStart, nameEnd)), (originalPricePoint, nil), (salePricePoint, nil)]
    return scanner(url: url, seller: "Nike", specifications: ["size": "9.5"], dividersAndStringLocators: dividersAndStringLocators)
}

struct scanner {
    let url: String
    let seller: String
    let specifications: [String: String]
    
    let dividersAndStringLocators: [(String, (String, String)?)]
    
//    var scanIntervalInSec = 600
    
    func scan() {
        Alamofire.request(.GET, url).responseString(completionHandler: {
            if $0.result.isSuccess {
                if let stringReturned = $0.result.value {
                    let items = allItems(stringReturned, dividersAndStringLocators: self.dividersAndStringLocators, specifications: self.specifications, seller: self.seller)
                    handleItems(items, seller: self.seller, db: realm)
                    print(items)
                } else {
                    print("Error: no string received for " + self.seller)
                }
            } else {
                print("Error: request failed for " + self.seller)
            }
        })
    }
}

func handleItems(items: [Item], seller: String, db: Realm) {
    let itemsToSave = items.map { itemToModel($0) }
//    itemsToSave.forEach { $0.setupAlreadyInDb(realm) }
    itemsToSave.forEach { $0.setupShownBefore(realm) }
    clearAllItems(seller)
    itemsToSave.forEach {x in
        try! db.write {
            db.add(x)
        }
    }
    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "scan done", object: nil))
}



