//
//  TimelineCell.swift
//  tweety
//
//  Created by Gale on 2/21/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    
    /*------------------*
     *      Outlets     *
     *------------------*/
    
    /* Labels */
    
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    /* Buttons */
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    /* Variables necessary for retweeting/favoriting */
    
    var tweetId : String?
    var didRetweet: Bool = false
    var didFavorite: Bool = false
    
    /*------------------------*
     *      Tweet Setter      *
     *------------------------*/
    
    var tweet: Tweet! {
        didSet {
            tweetId = String(tweet.tweetId)
            tweetLabel.text = tweet.text as? String
            timestampLabel.text = tweet.timestamp
            nameLabel.text = String(tweet.user!.name!)
            userImageView.setImageWithURL(tweet.user!.profileUrl!)
            userHandleLabel.text = "@\(tweet.user!.screenname!)"
            
            if tweet.retweetCount == 0 {
                retweetCount.text = ""
            } else {
                retweetCount.text = String(tweet.retweetCount)
            }
            
            if tweet.retweeted == true {
                retweetButton.setImage(UIImage(named: "retweet-action-on-green.png"), forState: UIControlState.Normal)
            }
            
            if tweet.favoriteCount == 0 {
                favoriteCount.text = ""
            } else {
                favoriteCount.text = String(tweet.favoriteCount)
            }
            
            if tweet.favorited == true {
                favoriteButton.setImage(UIImage(named: "like-action-on-red.png"), forState: UIControlState.Normal)
            }
            
            didRetweet = tweet.retweeted!
            didFavorite = tweet.favorited!
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        retweetCount.text = ""
        favoriteCount.text = ""
        userImageView.layer.cornerRadius = 4
        userImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*-------------------------*
     *      Button Actions     *
     *-------------------------*/

    /* Replying to a tweet */
    
    @IBAction func onReply(sender: AnyObject) {
    }
    
    
    /* Retweeting/Unretweeting */
    
    @IBAction func onRetweet(sender: AnyObject) {
        if !didRetweet {
            TwitterClient.sharedInstance.retweet(tweetId!)
            
            retweetButton.setImage(UIImage(named: "retweet-action-on-pressed_green.png"), forState: UIControlState.Highlighted)
            retweetButton.setImage(UIImage(named: "retweet-action-on-green.png"), forState: UIControlState.Normal)
            tweet.retweetCount += 1
            retweetCount.text = "\(tweet.retweetCount)"
            didRetweet = true
            
            print(tweet.retweetCount)
            
        } else {
            TwitterClient.sharedInstance.unretweet(tweetId!)
            retweetButton.setImage(UIImage(named: "retweet-action_default.png"), forState: UIControlState.Normal)
            tweet.retweetCount -= 1
            
            if tweet.retweetCount == 0 {
                retweetCount.text = ""
            } else {
                retweetCount.text = "\(tweet.retweetCount)"
            }
            didRetweet = false
            
            print(tweet.retweetCount)
        }
    }
    
    /* Favoriting/Unfavoriting */

    @IBAction func onFavorite(sender: AnyObject) {
        if !didFavorite {
            TwitterClient.sharedInstance.favorite(tweetId!)
            favoriteButton.setImage(UIImage(named: "like-action-on-pressed-red.png"), forState: UIControlState.Highlighted)
            favoriteButton.setImage(UIImage(named: "like-action-on-red.png"), forState: UIControlState.Normal)
            tweet.favoriteCount += 1
            favoriteCount.text = "\(tweet.favoriteCount)"
            didFavorite = true
        } else {
            TwitterClient.sharedInstance.unfavorite(tweetId!)
            favoriteButton.setImage(UIImage(named: "like-action-off.png"), forState: UIControlState.Normal)
            tweet.favoriteCount -= 1
            
            if tweet.favoriteCount == 0 {
                favoriteCount.text = ""
            } else {
                favoriteCount.text = "\(tweet.favoriteCount)"
            }
            didFavorite = false
        }
    }

}
