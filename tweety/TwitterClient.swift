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
    
    /**
     * Getting request token to open up authorize link in mobile safari
     */
    
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
    
    /**
     * Logs out of current user
     */
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    /**
     * Gets access tokens and saves user
     */
    
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
            
            
        }) { (error: NSError!) -> Void in
                self.loginFailure?(error)
        }
        
    }
    
    /**
     * GET /statuses/home_timeline/
     * Params: Int "max_id", Int "count"
     * Returns: Dictionary Tweets
     * Gets the home timeline of the current user. Can specify "max_id" to fetch statuses
     * older than the "max_id" and "count" to specify how many results should come back.
     */
    
    func homeTimeline(parameters: NSDictionary?, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        // Making a GET request to the home_timeline endpoint
        GET("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
        }, failure: { (task: NSURLSessionDataTask? , error: NSError) -> Void in
                failure(error)
        })
    }
    
    /**
     * GET /account/verify_credentials/
     * Params:
     * Returns: Dictionary User
     * Gets the current account.
     */
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        // Making a GET request to the verify_credentials endpoint (to get current account)
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            // Response as dictionary
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    /**
     * POST /statuses/retweet/
     * Params: String tweetId
     *
     * Retweets a status (specified by the tweetId) that isn't owned by the User.
     */
    
    func retweet(tweetId: String) {
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Retweeting a tweet!")
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        })
    }
    
    /**
     * POST /statuses/unretweet/
     * Params: String tweetId
     *
     * Unetweets a status (specified by the tweetId) that was already retweeted by the
     * User.
     */
    
    func unretweet(tweetId: String) {
        POST("1.1/statuses/unretweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Unretweeting a tweet!")
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        }
    }
    
    /**
     * POST /favorites/create/
     * Params: String tweetId
     *
     * Favorites a status (specified by the tweetId), can be a tweet owned by the User.
     */
    
    func favorite(tweetId: String) {
        POST("1.1/favorites/create.json?id=\(tweetId)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Favoriting a tweet")
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            print(error.localizedDescription)
        }
    }
    
    /**
     * POST /favorites/destroy/
     * Params: String tweetId
     *
     * Unfavorites a status (specified by the tweetId), can be a tweet owned by the User.
     */
    
    func unfavorite(tweetId: String) {
        POST("/1.1/favorites/destroy.json?id=\(tweetId)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Unfavoriting a tweet")
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        }
    }
    
    /**
     * POST /statuses/update/
     * Params: String status, String tweetId (Optional)
     *
     * Creates a tweet (with the status parameter) and replies to tweets (passing in 
     * the tweetId parameter).
     */
    
    func replyToTweet(apiParameters: NSDictionary) {
        POST("1.1/statuses/update.json", parameters: apiParameters, progress: nil, success:  { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Replying to a tweet")
            print(apiParameters)
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        }
    }
    
    func fetchingUserWithCompletion(apiParameters: NSDictionary?, completion: (user: User?, error: NSError?)-> ()) {
        GET("1.1/users/lookup.json", parameters: apiParameters, progress: { (progress: NSProgress) -> Void in
            }, success: {(operation: NSURLSessionDataTask, response: AnyObject?)-> Void in
                let user = User(dictionary: response![0] as! NSDictionary)
                completion(user: user, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error) -> Void in
                completion(user: nil, error: error)
        })
    }

}