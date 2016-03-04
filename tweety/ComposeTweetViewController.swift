//
//  ComposeTweetViewController.swift
//  tweety
//
//  Created by Gale on 2/27/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

@objc protocol ComposeTweetViewControllerDelegate {
    optional func composeTweetViewController(composeTweetViewController: ComposeTweetViewController, didUpdateTweet newTweet: Tweet)
}

class ComposeTweetViewController: UIViewController {
    
    weak var delegate: ComposeTweetViewControllerDelegate?
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextField.becomeFirstResponder()
        countLabel.text = "\(140 - tweetTextField.text!.characters.count)"

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
        TwitterClient.sharedInstance.replyToTweetWithCompletion(apiParameters) { (tweet, error) -> () in
            if tweet != nil {
                self.delegate?.composeTweetViewController!(self, didUpdateTweet: tweet!)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // MARK: - Text Field Functions
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if tweetTextField.text!.characters.count > maxLength {
            textField.deleteBackward()
        }
    }
    
    @IBAction func onEditingText(sender: AnyObject) {
        checkMaxLength(sender as! UITextField, maxLength: 140)
        countLabel.text = "\(140 - tweetTextField.text!.characters.count)"
        print(tweetTextField.text!.characters.count)
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
