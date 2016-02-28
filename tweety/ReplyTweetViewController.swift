//
//  ReplyTweetViewController.swift
//  tweety
//
//  Created by Gale on 2/27/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

class ReplyTweetViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!
    @IBOutlet weak var inReplyLabel: UILabel!
    
    var replyTo: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextField.becomeFirstResponder()
        inReplyLabel.text = "In reply to \(replyTo!.user!.name!)"
        tweetTextField.text = "@\(replyTo!.user!.screenname!) "
        print("Reply: \(replyTo?.tweetId)")
        countLabel.text = "\(140 - tweetTextField.text!.characters.count)"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Bar Button Actions
    
    @IBAction func onCloseButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweetButton(sender: AnyObject) {
        let apiParameters = NSMutableDictionary()
        apiParameters["status"] = tweetTextField.text!
        apiParameters["in_reply_to_status_id"] = replyTo!.tweetId
        TwitterClient.sharedInstance.replyToTweet(apiParameters)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Text Field Functions
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if tweetTextField.text!.characters.count > maxLength {
            textField.deleteBackward()
        }
    }
    
    @IBAction func onEditingTextField(sender: AnyObject) {
        checkMaxLength(sender as! UITextField, maxLength: 140)
        countLabel.text = "\(140 - tweetTextField.text!.characters.count)"
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