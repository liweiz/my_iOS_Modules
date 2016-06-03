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
    scanner_FootLocker_men_90_shoes_Jordan().scan()
    scanner_FootLocker_men_95_shoes_Jordan().scan()
    scanner_FootLocker_men_95_basketball_shoes_Nike().scan()
    
    scanner_FootLocker_Toddler_Boy_5_shoes().scan()
    scanner_FootLocker_Toddler_Boy_6_shoes().scan()
    scanner_FootLocker_Toddler_Boy_11_shoes().scan()
    scanner_FootLocker_Preschool_Boy_11_shoes().scan()
    scanner_FootLocker_Toddler_Boy_clothing().scan()
    scanner_FootLocker_men_M_clothing_Nike().scan()
    scanner_FootLocker_men_M_clothing_UnderArmour().scan()
    scanner_FootLocker_men_M_clothing_Jordan().scan()
    
    scanner_Lego().scan()
    scanner_Nike_men_95_running_shoes().scan()
    scanner_Nike_men_95_basketball_shoes().scan()
    scanner_Nike_men_socks().scan()
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
    let url = "https://www.footlocker.ca/en-CA/Sale/Mens/Nike/Shoes/Performance-Running-Shoes/_-_/N-1z141w4Z24ZzzZrjZgrZca?Rpp=180&cm_PAGE=180&Nr=AND%28P_RecordType%3AProduct%29"
    return scanner_FootLocker_shoe("9.5", urlToScan: url, category: "NikeRunningShoe")
}

func scanner_FootLocker_men_90_shoes_Jordan() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Mens/Jordan/Shoes/_-_/N-1z141w4Z24Z11cZrjZ5w?Rpp=180&cm_PAGE=180&Nr=AND%28P_RecordType%3AProduct%29"
    return scanner_FootLocker_shoe("9.0", urlToScan: url, category: "JordanShoe")
}

func scanner_FootLocker_men_95_shoes_Jordan() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Mens/Jordan/Shoes/_-_/N-1z141w4Z24Z11cZrjZca?Rpp=180&cm_PAGE=180&Nr=AND%28P_RecordType%3AProduct%29"
    return scanner_FootLocker_shoe("9.5", urlToScan: url, category: "JordanShoe")
}

func scanner_FootLocker_men_95_basketball_shoes_Nike() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Mens/Nike/Basketball/Shoes/_-_/N-1z141w4Z24ZzzZfmZrjZca?Rpp=180&cm_PAGE=180&Nr=AND%28P_RecordType%3AProduct%29"
    return scanner_FootLocker_shoe("9.5", urlToScan: url, category: "NikeBasketballShoe")
}

func scanner_FootLocker_Toddler_Boy_5_shoes() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Boys-Toddler/Shoes/_-_/N-1z141w4Z1giZrjZ5q?Rpp=180&cm_REF=05%2E0&Nr=AND%28P_RecordType%3AProduct%29"
    return scanner_FootLocker_shoe("5", urlToScan: url, category: "ZachSmallShoe")
}

func scanner_FootLocker_Toddler_Boy_6_shoes() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Boys-Toddler/Shoes/_-_/N-1z141w4Z1giZrjZ6m?Rpp=180&cm_PAGE=180&Nr=AND%28P_RecordType%3AProduct%29"
    return scanner_FootLocker_shoe("6", urlToScan: url, category: "ZachBigShoe")
}

func scanner_FootLocker_Toddler_Boy_11_shoes() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Boys-Toddler/Shoes/_-_/N-1z141w4Z1giZrjZ5j?Rpp=180&cm_PAGE=180&Nr=AND%28P_RecordType%3AProduct%29"
    return scanner_FootLocker_shoe("11", urlToScan: url, category: "ZionShoe")
}

func scanner_FootLocker_Preschool_Boy_11_shoes() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Boys-Preschool/Shoes/_-_/N-1z141w4Z1ghZrjZ5j?Rpp=180&cm_REF=Boys%27%20Preschool&Nr=AND%28P_RecordType%3AProduct%29"
    return scanner_FootLocker_shoe("11", urlToScan: url, category: "ZionShoe")
}

func scanner_FootLocker_Toddler_Boy_clothing() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Boys-Toddler/Clothing/_-_/N-1z141w4Z1giZrk?Rpp=180&cm_REF=Boys%27%20Toddler&Nr=AND%28P_RecordType%3AProduct%29"
    return scanner_FootLocker_shoe("All sizes", urlToScan: url, category: "ZionClothing")
}

func scanner_FootLocker_men_M_clothing_Nike() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Mens/Nike/Clothing/_-_/N-1z141w4Z24ZzzZrkZ2y?Rpp=180&cm_REF=M&Nr=AND%28P_RecordType%3AProduct%299"
    return scanner_FootLocker_shoe("M", urlToScan: url, category: "NikeClothing")
}

func scanner_FootLocker_men_M_clothing_UnderArmour() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Mens/Under-Armour/Clothing/_-_/N-1z141w4Z24Z10qZrkZ2y?Rpp=180&cm_REF=Under%20Armour&Nr=AND%28P_RecordType%3AProduct%29"
    return scanner_FootLocker_shoe("M", urlToScan: url, category: "UnderArmourClothing")
}

func scanner_FootLocker_men_M_clothing_Jordan() -> Scanner {
    let url = "https://www.footlocker.ca/en-CA/Sale/Mens/Jordan/Clothing/_-_/N-1z141w4Z24Z11cZrkZ2y?Rpp=180&cm_REF=Jordan&Nr=AND%28P_RecordType%3AProduct%29"
    return scanner_FootLocker_shoe("M", urlToScan: url, category: "JordanClothing")
}

func scanner_FootLocker_shoe(sizeToScan: String, urlToScan: String, category: String) -> Scanner {
    let namePoint = "quickviewEnabled" // Look for "title" follows.
    let originalPricePoint = "product_price"
    let salePricePoint = "<B>Now"
    
    let nameStart = "title=\""
    let nameEnd = "\" href="
    
    let dividersAndStringLocators: [(String, (String, String)?)] = [(namePoint, (nameStart, nameEnd)), (originalPricePoint, nil), (salePricePoint, nil)]
    return Scanner(url: urlToScan, seller: "Foot Locker", specifications: ["size": sizeToScan, "category": category], dividersAndStringLocators: dividersAndStringLocators)
}

func scanner_Nike_men_95_basketball_shoes() -> Scanner {
    let url = "http://store.nike.com/ca/en_gb/pw/mens-sale-basketball-shoes/47Z60wZ7puZ8r1Zoi3"
    return scanner_Nike_shoe("9.5", urlToScan: url, category: "BasketballShoe")
}

func scanner_Nike_men_95_running_shoes() -> Scanner {
    let url = "http://store.nike.com/ca/en_gb/pw/mens-sale-running-shoes/47Z60wZ7puZ8yzZoi3"
    return scanner_Nike_shoe("9.5", urlToScan: url, category: "RunningShoe")
}

func scanner_Nike_men_socks() -> Scanner {
    let url = "http://store.nike.com/ca/en_gb/pw/mens-sale-socks/47Z7puZ8r1Z9hkZ8yzZoneZpco"
    return scanner_Nike_shoe("_", urlToScan: url, category: "Socks")
}

func scanner_Nike_shoe(sizeToScan: String, urlToScan: String, category: String) -> Scanner {
    let namePoint = "grid-item-info" // Look for "title" follows.
    let originalPricePoint = "overridden nsg-font-family--base"
    let salePricePoint = "local nsg-font-family--base"
    
    let nameStart = "<p class=\"product-display-name nsg-font-family--base edf-font-size--regular nsg-text--dark-grey\" >"
    let nameEnd = "</p>"
    
    let dividersAndStringLocators: [(String, (String, String)?)] = [(namePoint, (nameStart, nameEnd)), (originalPricePoint, nil), (salePricePoint, nil)]
    return Scanner(url: urlToScan, seller: "Nike", specifications: ["size": sizeToScan, "category": category], dividersAndStringLocators: dividersAndStringLocators)
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
                    print("url"); print(self.self.url)
                    print("itemsFromHTML");print(items.count);print(items)
                    handleItems(items, category: self.seller + " " + specificationsInOneString(self.specifications), db: realm)
                } else {
                    print("Error: no string received for " + self.seller)
                }
            } else {
                print("Error: request failed for " + self.seller)
            }
        })
    }
}

func handleItems(items: [Item], category: String, db: Realm) {
    let itemsToSave = items.map { itemToModel($0) }
    //    itemsToSave.forEach { $0.setupAlreadyInDb(realm) }
    itemsToSave.forEach { $0.setupShownBefore(realm) }
    clearAllItems(category)
    
    itemsToSave.forEach {x in
        try! db.write {
            db.add(x)
        }
    }
    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "scan done", object: nil))
}