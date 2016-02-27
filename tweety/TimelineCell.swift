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
    
    /* Conditional Outlets */
    
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!

    /* Constraint Outlets */
    
    @IBOutlet weak var retweetedImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var retweetedImageToUserImage: NSLayoutConstraint!
    @IBOutlet weak var mediaImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mediaImageViewToReplyButton: NSLayoutConstraint!
    
    /* Variables necessary for retweeting/favoriting */
    
    var tweetId : String?
    var currentUserDidRetweet: Bool = false
    var currentUserDidFavorite: Bool = false
    
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
            
            if tweet.retweetedByCurrentUser == true {
                retweetButton.setImage(UIImage(named: "retweet-action-on-green.png"), forState: UIControlState.Normal)
            }
            
            if tweet.favoriteCount == 0 {
                favoriteCount.text = ""
            } else {
                favoriteCount.text = String(tweet.favoriteCount)
            }
            
            if tweet.favoritedByCurrentUser == true {
                favoriteButton.setImage(UIImage(named: "like-action-on-red.png"), forState: UIControlState.Normal)
            }
            
            currentUserDidRetweet = tweet.retweetedByCurrentUser!
            currentUserDidFavorite = tweet.favoritedByCurrentUser!
            
           /* retweetButton.enabled = true
            if tweet.user?.screenname == User._currentUser?.screenname {
                retweetButton.enabled = false
            }*/
            
            /* Conditional Elements (Edge cases) */
            
           /* if !tweet.wasRetweeted {
                retweetedLabel.hidden = true
                retweetedImageViewHeight.constant = 0
                retweetedImageToUserImage.constant = 0
                print(retweetedImageToUserImage.constant)
                print(retweetedImageViewHeight.constant)
                
            } else {
                retweetedLabel.hidden = false
                retweetedImageViewHeight.constant = 15
                retweetedImageToUserImage.constant = 6
                
                print(" In else \(retweetedImageToUserImage.constant)")
                print(retweetedImageViewHeight.constant)
                
                if tweet.wasRetweetedBy! == User._currentUser?.name {
                    retweetedLabel.text = "You retweeted"
                    
                } else {
                    retweetedLabel.text = "\(tweet.wasRetweetedBy!) retweeted"
                    
                }
            }
            
            mediaImageView.image = nil
            
            if tweet.imageUrl != nil {
                mediaImageView.setImageWithURL(tweet.imageUrl!)
                mediaImageViewHeight.constant = 142
                mediaImageViewToReplyButton.constant = 8
                
            } else {
                mediaImageViewHeight.constant = 0
                mediaImageViewToReplyButton.constant = 0
                
            }*/
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
        if !currentUserDidRetweet {
            TwitterClient.sharedInstance.retweet(tweetId!)
            
            retweetButton.setImage(UIImage(named: "retweet-action-on-pressed_green.png"), forState: UIControlState.Highlighted)
            retweetButton.setImage(UIImage(named: "retweet-action-on-green.png"), forState: UIControlState.Normal)
            
            tweet.retweetCount += 1
            retweetCount.text = "\(tweet.retweetCount)"
            currentUserDidRetweet = true
            
        } else {
            TwitterClient.sharedInstance.unretweet(tweetId!)
            
            retweetButton.setImage(UIImage(named: "retweet-action_default.png"), forState: UIControlState.Normal)
            tweet.retweetCount -= 1
            
            if tweet.retweetCount == 0 {
                retweetCount.text = ""
            } else {
                retweetCount.text = "\(tweet.retweetCount)"
            }
            currentUserDidRetweet = false
            
        }
    }
    
    /* Favoriting/Unfavoriting */

    @IBAction func onFavorite(sender: AnyObject) {
        if !currentUserDidFavorite {
            TwitterClient.sharedInstance.favorite(tweetId!)
            
            favoriteButton.setImage(UIImage(named: "like-action-on-pressed-red.png"), forState: UIControlState.Highlighted)
            favoriteButton.setImage(UIImage(named: "like-action-on-red.png"), forState: UIControlState.Normal)
            
            tweet.favoriteCount += 1
            favoriteCount.text = "\(tweet.favoriteCount)"
            currentUserDidFavorite = true
            
        } else {
            TwitterClient.sharedInstance.unfavorite(tweetId!)
            favoriteButton.setImage(UIImage(named: "like-action-off.png"), forState: UIControlState.Normal)
            tweet.favoriteCount -= 1
            
            if tweet.favoriteCount == 0 {
                favoriteCount.text = ""
                
            } else {
                favoriteCount.text = "\(tweet.favoriteCount)"
                
            }
            currentUserDidFavorite = false
            
        }
    }

}
