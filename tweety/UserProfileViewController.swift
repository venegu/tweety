//
//  UserProfileViewController.swift
//  tweety
//
//  Created by Gale on 3/1/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var user: User?
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var headerBannerImageView: UIImageView!
    @IBOutlet weak var blurBannerImageView: UIImageView!
    
    @IBOutlet weak var lineHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var profileImageTopMargin: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if user != nil {
            nameLabel.text = user!.name as? String
            handleLabel.text = "@\(user!.screenname as! String)"
            taglineLabel.text = user!.tagline as? String
            followingCountLabel.text = "\(user!.followingCount!)"
            followersCountLabel.text = "\(user!.followersCount!)"
            
            profileImageView.setImageWithURL(user!.profileUrlHigh!)
            
            headerBannerImageView.setImageWithURLRequest(NSURLRequest(URL: user!.profileBackgroundImage!), placeholderImage: nil, success: { (request, response, image) -> Void in
                self.headerBannerImageView.image = image
                
                print(self.user!.profileBackgroundImage!)
                }) { (request, response, error) -> Void in
                    print(error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
