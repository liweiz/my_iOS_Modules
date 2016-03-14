//
//  ViewController.swift
//  SaleWatcher
//
//  Created by Liwei Zhang on 2016-03-10.
//  Copyright © 2016 Liwei Zhang. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    var tableViewController: UITableViewController? = nil
    var timer: NSTimer? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scanAll()
        if timer == nil {
            if let n = nextTime(["0", "10", "20", "30", "40", "50"]) {
                timer = NSTimer(fireDate: n, interval: 10 * 60, target: self, selector: #selector(scan), userInfo: nil, repeats: true)
            } else {
                print("nextTime Error")
            }
        }
        if tableViewController == nil {
            tableViewController = TableViewController(style: UITableViewStyle.Plain)
            addChildViewController(tableViewController!)
            view.addSubview((tableViewController?.tableView)!)
            tableViewController?.didMoveToParentViewController(self)
            NSNotificationCenter.defaultCenter().addObserverForName("scan done", object: nil, queue: nil, usingBlock: { _ in
                (self.tableViewController as! TableViewController).refreshItems(realm)
                self.tableViewController?.tableView.reloadData()
            })
        }
        
    }
    func scan() {
        scanAll()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




