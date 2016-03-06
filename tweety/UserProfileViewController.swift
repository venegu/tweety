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
    @IBOutlet weak var headerBackground: UIView!
    @IBOutlet weak var tweetsSegmentControl: UISegmentedControl!
    @IBOutlet weak var hiddenNameLabel: UILabel!
    @IBOutlet weak var numberOfLabel: UILabel!
    
    
    @IBOutlet weak var lineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageTopMargin: NSLayoutConstraint!
    
    var offsetHeaderViewStop: CGFloat!
    var offsetHeader: CGFloat?
    var offsetHeaderBackgroundViewStop: CGFloat!
    var offsetNavigationLabelViewStop: CGFloat!
    var navigationBarHeight: CGFloat!
    
    var pan: UIPanGestureRecognizer!
    
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
            
            if user!.profileBackgroundImage != nil {
                headerBannerImageView.setImageWithURLRequest(NSURLRequest(URL: user!.profileBackgroundImage!), placeholderImage: nil, success: { (request, response, image) -> Void in
                    self.headerBannerImageView.image = image
                    

                    }) { (request, response, error) -> Void in
                    print(error.localizedDescription)
                }
            }
        }
        
        // Hiding labels for the navigation bar
        hiddenNameLabel.hidden = true
        numberOfLabel.hidden = true
        
        // Making sure header image does not overflow
        navigationBarHeight = navigationController!.navigationBar.frame.size.height + navigationController!.navigationBar.frame.origin.y
        offsetHeaderViewStop = tweetsSegmentControl.frame.origin.y - navigationBarHeight - 8
        offsetHeaderBackgroundViewStop = (headerBackground.frame.size.height + headerBackground.frame.origin.y) - navigationBarHeight
        offsetNavigationLabelViewStop = hiddenNameLabel.frame.origin.y - (navigationBarHeight / 2) + 8
        headerBackground.clipsToBounds = true
        lineHeightConstraint.constant = 1 / UIScreen.mainScreen().scale
        
        // Profile image white border border
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.borderWidth = 4.0
        profileImageTopMargin.constant = navigationBarHeight + 4.0
        profileImageView.layer.zPosition = 1
        
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
