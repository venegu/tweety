//
//  User.swift
//  tweety
//
//  Created by Gale on 2/21/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileUrlLow: NSURL?
    var profileUrlHigh: NSURL?
    var profileBannerImage: NSURL?
    var profileBackgroundImage: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    var id: Int?
    var tweetsCount: Int?
    var likesCount: Int?
    var followingCount: Int?
    var followersCount: Int?
    
    // Constructor to deserialize properties retrieved from the API
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString {
            profileUrlLow = NSURL(string: profileUrlString)
            profileUrlHigh = NSURL(string: profileUrlString.stringByReplacingOccurrencesOfString("_normal", withString: ""))
        }
        
        tagline = dictionary["description"] as? String
        id = dictionary["id"] as? Int
        
        tweetsCount = dictionary["statuses_count"] as? Int
        likesCount = dictionary["favourites_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        
    }
    
    static var _currentUser: User?
    
    static var userDidLogoutNotification = "UserDidLogout"
    
    // Persisting current user
    class var currentUser: User? {
        // Getter for computed properties
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: [])
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
        
            }
        
            return _currentUser
        }
        
        // Setter for computer properties
        set(user) {
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
                defaults.synchronize()
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
        }
    }

}
