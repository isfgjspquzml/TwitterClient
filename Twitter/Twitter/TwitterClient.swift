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
    class var client :TwitterClient {
    struct Singleton {
        static let instance = TwitterClient()
        }
        return Singleton.instance
    }
    
    let accountStore: ACAccountStore!
    let accountType: ACAccountType!
    let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    var feedViewController: FeedViewController!
    
    var user: User?
    var statuses: [Status]?
    var account: ACAccount?
    var storedTweet: String = ""
    var storedReplyTweet: String = ""
    
    override init() {
        accountStore = ACAccountStore()
        accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    }
    
    func getAccount() {
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (success, error) in
            if success {
                let accounts = self.accountStore.accountsWithAccountType(self.accountType)
                if accounts.count > 0 {
                    self.account = accounts![0] as? ACAccount
                }
                self.updateUser()
                self.updateStatuses()
            } else {
                NSLog("Error: \(error)")
            }
        }
    }
    
    func updateUser() {
        if account == nil {return}
        let url = NSURL(string: "https://api.twitter.com/1.1/users/show.json")
        let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: NSDictionary(object: account!.username, forKey: "screen_name"))
        
        authRequest.account = account
        let request = authRequest.preparedURLRequest()
        
        let task = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            if error != nil {
                NSLog("Error getting user credentials")
            } else {
                let userInfo = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.user = User(dictionary: userInfo)
            }
        })
        task.resume()
    }
    
    func updateStatuses() {
        if account == nil {return}
        let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: nil)
        
        authRequest.account = account
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
    }
    
    func tweetMessage(message: String) {
        if account == nil {return}
//        https://api.twitter.com/1.1/statuses/update.json
    }
    
    func retweetTweet() {
        
    }
    
    func favoriteTweet() {
        
    }
    
    func replyToTweet() {
        
    }
}
