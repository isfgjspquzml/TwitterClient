//
//  ViewController.swift
//  Twitter
//
//  Created by Tianyu Shi on 9/24/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let client: TwitterClient = TwitterClient()
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        client.feedViewController = self
        client.getAccount()
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.addSubview(refreshControl!)
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
    
    func refresh(sender: AnyObject) {
        let dateFormater = NSDateFormatter()
        dateFormater.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
        let title = "Updated " + dateFormater.stringFromDate(NSDate())
        let attrDict = NSDictionary(object: UIColor.blackColor(), forKey: NSForegroundColorAttributeName)
        let attrString = NSAttributedString(string: title, attributes: attrDict)
        client.updateStatuses()
        feedTableView.reloadData()
        refreshControl!.attributedTitle = attrString
        refreshControl?.endRefreshing()
    }
}

