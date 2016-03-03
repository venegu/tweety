//
//  Tweet.swift
//  tweety
//
//  Created by Gale on 2/21/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var tweetId: Int = 0
    var text: NSString?
    var timestamp: String?
    var timestampString: NSString?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var retweetedByCurrentUser: Bool? = false
    var favoritedByCurrentUser: Bool? = false
    var wasRetweeted = false
    var wasRetweetedBy: String?
    var userId: Int?
    var imageUrl: NSURL?
    
    init(dictionary: NSDictionary) {
        
        if let retweetedTweet = dictionary["retweeted_status"] {
            user = User(dictionary: (retweetedTweet["user"] as? NSDictionary)!)
            tweetId = (retweetedTweet["id"] as? Int) ?? 0
            text = retweetedTweet["text"] as? String
            retweetCount = (retweetedTweet["retweeted_count"] as? Int) ?? 0
            favoriteCount = (retweetedTweet["favorite_count"] as? Int) ?? 0
            wasRetweeted = true
            wasRetweetedBy = dictionary["user"]!["name"] as? String
            timestampString = retweetedTweet["created_at"] as? String
            userId = user?.id
        
        } else {
            user = User(dictionary: dictionary["user"] as! NSDictionary)
            tweetId = (dictionary["id"] as? Int) ?? 0
            text = dictionary["text"] as? String
            retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
            favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
            wasRetweeted = false
            timestampString = dictionary["created_at"] as? String
            userId = user?.id
        }
        
        retweetedByCurrentUser = dictionary["retweeted"] as? Bool
        favoritedByCurrentUser = dictionary["favorited"] as? Bool
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.timeZone = NSTimeZone.localTimeZone()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            let times = formatter.dateFromString(timestampString as String)?.timeIntervalSinceNow
            timestamp = Tweet.gettingTimestamp(times!)
        }
        
        if let mediaContent = dictionary["extended_entities"] as? NSDictionary {
            if mediaContent["media"]![0]["type"] as! String == "photo" {
                imageUrl = NSURL(string: (mediaContent["media"]![0]["media_url_https"] as! String))
            }
        }
        
    }
    
    // Passing all tweets into an array
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    class func gettingTimestamp(time : NSTimeInterval) -> String {
        let timeSeconds = -Int(time)
        var timeSince: Int = 0
        
        if timeSeconds == 0 {
            return "Now"
        }
        
        if timeSeconds <= 60 {
            timeSince = timeSeconds
            return "\(timeSince)s"
        }
        
        if timeSeconds/60 < 60 {
            timeSince = timeSeconds/60
            return "\(timeSince)m"
        }
        
        if (timeSeconds/60)/60 < 24 {
            timeSince = (timeSeconds/60)/60
            return "\(timeSince)h"
        }
        
        if ((timeSeconds/60)/60)/24 < 365 {
            timeSince = ((timeSeconds/60)/60)/24
            return "\(timeSince)d"
        }
        
        if (((timeSeconds/60)/60)/24)/365 < 100 {
            timeSince = ((((timeSeconds)/60)/60)/24)/365
            return "\(timeSince)y"
        }
        
        return "\(timeSince)"
    }
    
}