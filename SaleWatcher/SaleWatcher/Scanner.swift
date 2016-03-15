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
    scanner_FootLocker_men_95_performance_running_shoes_Nike().scan()
    scanner_FootLocker_men_95_classic_basketball_shoes_Jordan().scan()
    scanner_FootLocker_men_100_performance_basketball_shoes_Nike().scan()
    scanner_FootLocker_men_95_performance_basketball_shoes_Nike().scan()
    scanner_Lego().scan()
    scanner_Nike_men_95_running_shoes().scan()
}

func scanner_Lego() -> Scanner {
    let url = "http://shop.lego.com/en-CA/Sales-And-Deals"
    let namePoint = "Quick View" // Look for "title" follows.
    let originalPricePoint = "was-price"
    let salePricePoint = "now-price"
    
    let nameStart = "<a title=\""
    let nameEnd = "\" href=\""
    
    let dividersAndStringLocators: [(String, (String, String)?)] = [(namePoint, (nameStart, nameEnd)), (originalPricePoint, nil), (salePricePoint, nil)]
    return Scanner(url: url, seller: "Lego", specifications: ["": ""], dividersAndStringLocators: dividersAndStringLocators)
}

func scanner_FootLocker_men_95_performance_running_shoes_Nike() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Mens/Nike/Shoes/Performance-Running-Shoes/_-_/N-1z141w4Z24ZzzZrjZgrZca"
    return scanner_FootLocker_shoe("9.5", urlToScan: url)
}

func scanner_FootLocker_men_95_classic_basketball_shoes_Jordan() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Mens/Jordan/Shoes/Classic-Basketball-Shoes/_-_/N-1z141w4Z24Z11cZrjZ1ssZca"
    return scanner_FootLocker_shoe("9.5", urlToScan: url)
}

func scanner_FootLocker_men_100_performance_basketball_shoes_Nike() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Mens/Nike/Shoes/Performance-Basketball-Shoes/_-_/N-1z141w4Z24ZzzZrjZseZ5v"
    return scanner_FootLocker_shoe("10.0", urlToScan: url)
}

func scanner_FootLocker_men_95_performance_basketball_shoes_Nike() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Mens/Nike/Shoes/Performance-Basketball-Shoes/_-_/N-1z141w4Z24ZzzZrjZseZca"
    return scanner_FootLocker_shoe("9.5", urlToScan: url)
}

func scanner_FootLocker_shoe(sizeToScan: String, urlToScan: String) -> Scanner {
    let namePoint = "quickviewEnabled" // Look for "title" follows.
    let originalPricePoint = "product_price"
    let salePricePoint = "<B>Now"
    
    let nameStart = "title=\""
    let nameEnd = "\" href="
    
    let dividersAndStringLocators: [(String, (String, String)?)] = [(namePoint, (nameStart, nameEnd)), (originalPricePoint, nil), (salePricePoint, nil)]
    return Scanner(url: urlToScan, seller: "Foot Locker", specifications: ["size": sizeToScan], dividersAndStringLocators: dividersAndStringLocators)
}

func scanner_Nike_men_95_basketball_shoes() -> Scanner {
    let url = ""
    return scanner_Nike_shoe("9.5", urlToScan: url)
}

func scanner_Nike_men_95_running_shoes() -> Scanner {
    let url = "http://store.nike.com/ca/en_gb/pw/mens-sale-running-shoes/47Z60wZ7puZ8yzZoi3"
    return scanner_Nike_shoe("9.5", urlToScan: url)
}

func scanner_Nike_shoe(sizeToScan: String, urlToScan: String) -> Scanner {
    let namePoint = "grid-item-info" // Look for "title" follows.
    let originalPricePoint = "<span class=\"overridden nsg-font-family--base\">"
    let salePricePoint = "<span class=\"local nsg-font-family--base\">"
    
    let nameStart = "<p class=\"product-display-name nsg-font-family--base edf-font-size--regular nsg-text--dark-grey\" >"
    let nameEnd = "</p>"
    
    let dividersAndStringLocators: [(String, (String, String)?)] = [(namePoint, (nameStart, nameEnd)), (originalPricePoint, nil), (salePricePoint, nil)]
    return Scanner(url: urlToScan, seller: "Nike", specifications: ["size": sizeToScan], dividersAndStringLocators: dividersAndStringLocators)
}

struct Scanner {
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



