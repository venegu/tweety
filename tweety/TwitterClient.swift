//
//  TwitterClient.swift
//  tweety
//
//  Created by Gale on 2/21/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com/"), consumerKey: delegate.retrieveKeys("key"), consumerSecret: delegate.retrieveKeys("secret"))
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        // Making a GET request to the home_timeline endpoint
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
        }, failure: { (task: NSURLSessionDataTask? , error: NSError) -> Void in
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        // Making a GET request to the verify_credentials endpoint (to get current account)
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("account: \(response)")
            
            // Response as dictionary
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            
            success(user)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
}
