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
    var items = [String: [ItemOnSale]]()
    var categories: [String] {
        return Array(items.keys)
    }
    func refreshItems(db: Realm) {
        items = itemsFromDb(db)
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return categories.count
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (items[categories[section]]?.count)!
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "aCell"
        let cell: UITableViewCell
        if let c = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
            cell = c
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        let i = items[categories[indexPath.section]]![indexPath.row]
        cell.textLabel?.text = i.name + " " + i.specifications
        cell.detailTextLabel?.text = String(i.discount) + " " + i.salePrice + " " + i.originalPrice
        cell.backgroundColor = i.shownBefore ? UIColor.clearColor() : UIColor.greenColor()
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let i = (items[categories[indexPath.section]])![indexPath.row]
        markAsShown(realm, obj: i)
        tableView.cellForRowAtIndexPath(indexPath)!.backgroundColor = UIColor.clearColor()
    }
}