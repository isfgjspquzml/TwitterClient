//
//  TwitterClient.swift
//  Twitter
//
//  Created by Tianyu Shi on 9/25/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit
import Social
import Accounts

class TwitterClient: NSObject {
    let accountStore: ACAccountStore!
    let accountType: ACAccountType!
    let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    var feedViewController: FeedViewController!
    var statuses: [Status]?
    
    override init() {
        accountStore = ACAccountStore()
        accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    }
    
    func getStatuses() -> [Status]? {
        return statuses
    }
    
    func updateStatuses() {
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (success, error) in
            if success {
                let accounts = self.accountStore.accountsWithAccountType(self.accountType)
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
                            self.feedViewController.feedTableView.reloadData()
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
}
