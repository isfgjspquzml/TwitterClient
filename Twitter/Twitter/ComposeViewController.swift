//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Tianyu Shi on 9/27/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    
    @IBAction func onBackgroundTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {
            if self.feedViewControllerDelegate != nil {
                if countElements(self.composeTextView.text) > 0 {
                    TwitterClient.client.storedTweet = self.composeTextView.text
                }
            } else {
                if countElements(self.composeTextView.text) > 0 {
                    TwitterClient.client.storedReplyTweet = self.composeTextView.text
                }
            }
        })
    }
    
    
    
    var feedViewControllerDelegate: FeedViewController!
    var tweetViewControllerDelegate: TweetViewController!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if self.feedViewControllerDelegate != nil {
            if countElements(TwitterClient.client.storedTweet) > 0 {
                composeTextView.text = TwitterClient.client.storedTweet
            }
            tweetButton.setTitle("Tweet", forState: .Normal)
        } else {
            if countElements(TwitterClient.client.storedReplyTweet) > 0 {
                composeTextView.text = TwitterClient.client.storedReplyTweet
            }
            tweetButton.setTitle("Reply", forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Compose a Tweet!"
        let user: User? = TwitterClient.client.user
        if user != nil {
            self.nameLabel.text = user!.name
            self.usernameLabel.text = "@" + user!.username!
            self.userProfileImageView.image = user!.profileImage
            self.charCountLabel.text = String(140 - countElements(TwitterClient.client.storedTweet))
            self.userProfileImageView.layer.cornerRadius = 3
            self.userProfileImageView.clipsToBounds = true
            self.composeTextView.clipsToBounds = true
            self.composeTextView.layer.cornerRadius = 10
            self.composeView.layer.cornerRadius = 5;
            self.composeView.layer.masksToBounds = true;
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.feedViewControllerDelegate != nil {
            feedViewControllerDelegate!.returnFromComposeView()
        } else {
            tweetViewControllerDelegate!.returnFromComposeView()
        }
    }
}
