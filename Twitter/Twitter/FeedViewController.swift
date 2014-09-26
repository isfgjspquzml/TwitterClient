//
//  ViewController.swift
//  Twitter
//
//  Created by Tianyu Shi on 9/24/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource {
    let client: TwitterClient = TwitterClient()
    
    @IBOutlet weak var feedTableView: UITableView!
    
    @IBAction func didTapComposeView(sender: UIBarButtonItem) {
        let composeView = ComposeViewController(nibName: nil, bundle: nil)
        
        //        self.navigationController?.presentedViewController(composeView, animated: true, completion: {
        //
        //        })
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        client.feedViewController = self
        client.updateStatuses()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.estimatedRowHeight = 90
        feedTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCellWithIdentifier("statusCell") as StatusTableViewCell
        let status = client.getStatuses()?[indexPath.row]
        cell.status = status
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if client.getStatuses()?.count > 0 {
            return client.getStatuses()!.count
        } else {
            return 0
        }
    }
}

