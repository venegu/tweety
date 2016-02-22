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
    var text: NSString?
    var timestamp: NSDate?
    var timestampString: NSString?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString as String)
            //print(timestamp)
            
            //timestamp = NSDate.offsetFrom(time!)
            
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

}

/*extension NSDate {
    
    func yearsFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    
    func monthsFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    
    func weeksFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    
    func daysFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    
    func hoursFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    
    func minutesFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    
    func secondsFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    
    func offsetFrom(date: NSDate) -> String {
        if yearsFrom(date) > 0 {
            print("\(yearsFrom(date))y")
        }
        if monthsFrom(date) > 0 {
            print("\(monthsFrom(date))M")
        }
        if weeksFrom(date) > 0 {
            print("\(weeksFrom(date))w")
        }
        if daysFrom(date) > 0 {
            print("\(daysFrom(date))d")
        }
        if hoursFrom(date) > 0 {
            print("\(hoursFrom(date))h")
        }
        if minutesFrom(date) > 0 {
            print("\(minutesFrom(date))m")
        }
        if secondsFrom(date) > 0 {
            print("\(secondsFrom(date))s")
        }
        return ""
    }
}
*/