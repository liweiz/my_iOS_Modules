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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scanner_FootLocker_men_95_performance_basketball_shoes().scan()
        scanner_Lego().scan()
        scanner_Nike_men_95_running_shoes().scan()
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}




