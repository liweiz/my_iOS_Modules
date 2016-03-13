//
//  TableViewController.swift
//  SaleWatcher
//
//  Created by Liwei Zhang on 2016-03-11.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

//func tableViewController(rect: CGRect) -> UITableViewController {
//    var ctl = UITableViewController(style: UITableViewStyle.Plain)
//    ctl.refreshControl = UIRefreshControl()
//    ctl.tableView = UITableView(frame: rect)
//    ctl.
//    return ctl
//}

class TableViewController: UITableViewController {
    override func loadView() {
        super.loadView()
        if tableView == nil {
            tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
            tableView.delegate = self
            tableView.dataSource = self
        }
        refreshItems(realm)
        tableView.reloadData()
    }
    let sellers = ["Foot Locker", "Nike", "Lego"]
    var sellersAvailable: [String] {
        return sellers.filter { items.keys.contains($0) }
    }
    var items = [String: [ItemOnSale]]()
    func refreshItems(db: Realm) {
        items = itemsFromDb(db)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.keys.count
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sellersAvailable[section]
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items[sellersAvailable[section]]?.count)!
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "aCell"
        let cell: UITableViewCell
        if let c = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
            cell = c
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        let i = items[sellersAvailable[indexPath.section]]![indexPath.row]
        cell.textLabel?.text = i.name + " " + i.specifications
        cell.detailTextLabel?.text = String(i.discount) + " " + i.salePrice + " " + i.originalPrice
        cell.backgroundColor = i.alreadyInDb ? UIColor.clearColor() : UIColor.greenColor()
        return cell
    }
    
}