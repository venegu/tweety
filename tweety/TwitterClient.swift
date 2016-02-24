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
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        
        // Getting request token (oauth 1.0) and opening in tweety w/callback url - if successful return request token to allow us to send the user to the authorize url else error
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweetydemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            // Opening up authorize link in mobile safari & providing token - openURL switches out of your application into something else
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error: NSError!) -> Void in
                self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        // Getting access tokens
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            //print("I got the access token")
            
            self.currentAccount({ (user: User) -> () in
                
                // Calling setter and saving user
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
            
            /*
            currentAccount({ (user: User) -> () in
            print(user.name)
            print(user.screenname)
            print(user.profileUrl)
            print(user.tagline)
            }, failure: {(error: NSError) -> () in
            print(error.localizedDescription)
            })*/
            
            }) { (error: NSError!) -> Void in
                self.loginFailure?(error)
        }
        
    }
    
    func homeTimeline(parameters: NSDictionary?, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        // Making a GET request to the home_timeline endpoint
        GET("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            //print("Tweets: \(dictionaries)")
            
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
    
    func retweet(tweetId: String) {
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Retweeting a tweet!")
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        })
    }
    
    func unRetweet(tweetId: String) {
        POST("1.1/statuses/unretweet/\(tweetId).json", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Unretweeting a tweet!")
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
            }
        )
    }

}