//
//  TimelineCell.swift
//  tweety
//
//  Created by Gale on 2/21/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweetId : String?
    var retweetCounter : Int?
    
    var tweet: Tweet! {
        didSet {
            tweetId = String(tweet.tweetId)
            tweetLabel.text = tweet.text as? String
            retweetCount.text = String(tweet.retweetCount)
            favoriteCount.text = String(tweet.favoriteCount)
            retweetCounter = tweet.favoriteCount
        }
    }
    
    var didRetweet: Bool = false
    var didFavorite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        retweetCount.text = ""
        favoriteCount.text = ""
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onReply(sender: AnyObject) {
    }
    

    @IBAction func onRetweet(sender: AnyObject) {
        if !didRetweet {
            print(retweetCounter!)
            TwitterClient.sharedInstance.retweet(tweetId!)
            
            retweetButton.setImage(UIImage(named: "retweet-action-on-pressed_green.png"), forState: UIControlState.Normal)
            retweetButton.setImage(UIImage(named: "retweet-action-on-green.png"), forState: UIControlState.Normal)
            retweetCounter = retweetCounter! + 1
            retweetCount.text = "\(retweetCounter!)"
            didRetweet = true
            
        } else {
            TwitterClient.sharedInstance.unRetweet(tweetId!)
            retweetButton.setImage(UIImage(named: "retweet-action_default.png"), forState: UIControlState.Normal)
            retweetCounter = retweetCounter! - 1
            retweetCount.text = "\(retweetCounter!)"
        }
    }
    
    
    @IBAction func onFavorite(sender: AnyObject) {
    }

}
