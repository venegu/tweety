//
//  ComposeTweetViewController.swift
//  tweety
//
//  Created by Gale on 2/27/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextField.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    
    @IBAction func onCloseButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweetButton(sender: AnyObject) {
        let apiParameters = NSMutableDictionary()
        apiParameters["status"] = tweetTextField.text!
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
        countLabel.text = "\(140-tweetTextField.text!.characters.count)"
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
