//
//  TweetViewController.swift
//  Twitter
//
//  Created by Tianyu Shi on 9/27/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var numRetweets: UILabel!
    @IBOutlet weak var numFavorites: UILabel!
    
    @IBAction func onReplyTapped(sender: AnyObject) {
    }
    
    @IBAction func onRetweetTapped(sender: AnyObject) {
    }
    
    @IBAction func onFavoriteTapped(sender: AnyObject) {
    }
    
    @IBAction func onReturnTapped(sender: AnyObject) {
        
        feedViewControllerDelegate!.returnFromTweetView()
        
    }
    
    var status: Status?
    var feedViewControllerDelegate: FeedViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() in
            let imageRequest = NSURL.URLWithString(self.status!.profileImageURL)
            var err: NSError?
            let imageData = NSData.dataWithContentsOfURL(imageRequest,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
            if err == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.profileImageView.image = UIImage(data: imageData)
                    self.profileImageView.layer.cornerRadius = 3
                    self.profileImageView.clipsToBounds = true
                })
            }
        })
        
        nameLabel.text = status!.name
        usernameLabel.text = "@" + status!.username
        tweetLabel.text = status!.text
        
        let dateFormater = NSDateFormatter()
        dateFormater.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
        timeStampLabel.text = dateFormater.stringFromDate(NSDate(timeIntervalSince1970: status!.timeStamp!))
        
        numRetweets.text = String(status!.retweetCount)
        numFavorites.text = String(status!.favoriteCount)
    }
    
    func numRetweetsChanged(label: UILabel) {
        if status!.retweeted == 0 {
            label.font = UIFont(name: "System", size: 12)
        } else {
            label.font = UIFont(name: "System-Bold", size: 12)
        }
    }
    
    func numFavoritesChanged(label: UILabel) {
        if status!.favorited == 1 {
            label.font = UIFont(name: "System", size: 12)
        } else {
            label.font = UIFont(name: "System-Bold", size: 12)
        }
    }
}
