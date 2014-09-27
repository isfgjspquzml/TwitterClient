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
            if countElements(self.composeTextView.text) > 0 {
                self.client.storedTweet = self.composeTextView.text
            }
        })
    }
    
    var client = TwitterClient.client
    var feedViewControllerDelegate: FeedViewController!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if client.storedTweet != nil && countElements(client.storedTweet!) > 0 {
            composeTextView.text = client.storedTweet
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userImageView.layer.cornerRadius = 3
        self.userImageView.clipsToBounds = true
    }

    override func viewWillDisappear(animated: Bool) {
        feedViewControllerDelegate!.returnFromComposeView()
    }
}
