//
//  AppDelegate.swift
//  tweety
//
//  Created by Gale on 2/19/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Function to retrieve any necessary keys from key.plist
    func retrieveKeys(neededValue : String) -> String {
        if let path = NSBundle.mainBundle().pathForResource("key", ofType: "plist"), dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            if neededValue == "key" {
                return (dict["consumerKey"] as? String)!
            }
            
            if neededValue == "secret" {
                return (dict["consumerSecret"] as? String)!
            }
        }
        return "Provide a paramater!"
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // When app changes from a link this function is called
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com/"), consumerKey: self.retrieveKeys("key"), consumerSecret: self.retrieveKeys("secret"))
        
        // Getting access tokens
        twitterClient.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("I got the access token")
            
            // Making a GET request to the verify_credentials endpoint (to get current account)
            twitterClient.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("account: \(response)")
                
                // Response as dictionary
                let userDictionary = response as? NSDictionary
                let user = User(dictionary: userDictionary!)
                print("name: \(user.name)")
                print("screenname: \(user.screenname)")
                print("profile_url: \(user.profileUrl)")
                print("description: \(user.tagline)")
                
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                
            })
            
            // Making a GET request to the home_timeline endpoint
            twitterClient.GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = response as! [NSDictionary]
                /*for tweet in tweets {
                    print("\(tweet["text"]!)")
                }*/
                
            }, failure: { (task: NSURLSessionDataTask? , error: NSError) -> Void in
                    print("something went wrong: \(error.localizedDescription)")
                    
            })
            
        }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
        }
        
        return true
    }

}

