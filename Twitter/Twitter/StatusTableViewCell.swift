//
//  StatusTableViewCell.swift
//  Twitter
//
//  Created by Tianyu Shi on 9/24/14.
//  Copyright (c) 2014 Tianyu. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    var status: Status! {
        willSet(status) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() in
                let imageRequest = NSURL.URLWithString(status.profileImageURL)
                var err: NSError?
                let imageData = NSData.dataWithContentsOfURL(imageRequest,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
                if err != nil {
                    dispatch_async(dispatch_get_main_queue(), {() in
                        self.userImageView.image = UIImage(data: imageData)
                    })
                }
            })
            nameLabel.text = status.name
            usernameLabel.text = "@" + status.username
            tweetLabel.text = status.text
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
