//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Tianyu Shi on 9/24/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            NSLog("User info: \(notification.userInfo)")
            let value = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
            let rect = value.CGRectValue()
            NSLog("Height: \(rect.size.height)")
            return ()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
