//
//  TableViewController.swift
//  SaleWatcher
//
//  Created by Liwei Zhang on 2016-03-11.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import Foundation
import UIKit


//func tableViewController(rect: CGRect) -> UITableViewController {
//    var ctl = UITableViewController(style: UITableViewStyle.Plain)
//    ctl.refreshControl = UIRefreshControl()
//    ctl.tableView = UITableView(frame: rect)
//    ctl.
//    return ctl
//}


class TableViewController: UITableViewController {
    override func loadView() {
        if tableView == nil {
            tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
            tableView.delegate = self
            tableView.dataSource = self
        }
        tableView.reloadData()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        <#code#>
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        <#code#>
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
}