//
//  LoginViewController.swift
//  tweety
//
//  Created by Gale on 2/19/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        
        // Clearing previous sessions - do this b/c of BDBO bug
        TwitterClient.sharedInstance.deauthorize()
        
        // Getting request token (oauth 1.0) and opening in tweety w/callback url - if successful return request token to allow us to send the user to the authorize url else error
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweetydemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token!")
            
            // Opening up authorize link in mobile safari & providing token - openURL switches out of your application into something else
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
