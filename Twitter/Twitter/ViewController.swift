//
//  ViewController.swift
//  Twitter
//
//  Created by Tianyu Shi on 9/24/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit
import Social
import Accounts

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    @IBAction func didTapComposeView(sender: UIBarButtonItem) {
            let composeView = ComposeViewController(nibName: nil, bundle: nil)
        
//        self.navigationController?.presentedViewController(composeView, animated: true, completion: {
//            
//        })
    }
    
    let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var statuses: [Status]?

    override func viewDidLoad() {
        super.viewDidLoad()
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (success, error) in
            if success {
                let accounts = accountStore.accountsWithAccountType(accountType)
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: nil)
                
                authRequest.account = accounts[0] as ACAccount
                let request = authRequest.preparedURLRequest()
                
                let task = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                    if error != nil {
                        NSLog("Error getting timeline")
                    } else {
                        let array = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
                        var statusArray:[Status] = Array()
                        for object in array {
                            let dictionary = object as NSDictionary
                            statusArray.append((Status(dictionary: dictionary)))
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.statuses = statusArray
                            self.feedTableView.reloadData()
                        })
                    }
                })
                task.resume()
                NSLog("Accounts: \(accounts)")
            } else {
                NSLog("Error: \(error)")
            }
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCellWithIdentifier("statusCell") as StatusTableViewCell
        let status = self.statuses![indexPath.row]
        cell.tweetLabel.text = status.text
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statuses != nil {
            return statuses!.count
        } else {
            return 0
        }
    }
}

