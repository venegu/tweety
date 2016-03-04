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

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var headerBannerImageView: UIImageView!
    @IBOutlet weak var blurBannerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user)
        // Do any additional setup after loading the view.
        if user != nil {
            nameLabel.text = user!.name as? String
            handleLabel.text = "@\(user!.screenname as! String)"
            taglineLabel.text = user!.tagline as? String
            followingCountLabel.text = "\(user!.followingCount)"
            followersCountLabel.text = "\(user!.followersCount)"
        
        profileImageView.setImageWithURL(user!.profileUrlHigh!)
        
            headerBannerImageView.setImageWithURLRequest(NSURLRequest(URL: user!.profileBackgroundImage!), placeholderImage: nil, success: { (request, response, image) -> Void in
                self.headerBannerImageView.image = image
                
                print(self.user!.profileBackgroundImage!)
                }) { (request, response, error) -> Void in
                    print(error.localizedDescription)
            }
        }
        setupNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar() {
        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.translucent = true;
        navigationController!.view.backgroundColor = UIColor.clearColor()
        navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        
        let rightBtn = UIButton(type: .System)
        rightBtn.frame = CGRectMake(0, 0, 30, 30);
        let composeImage = UIImage(named: "icon_compose")
        //rightBtn.setImage(composeImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        rightBtn.tintColor = UIColor.whiteColor()
        rightBtn.addTarget(self, action: "onCompose", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightBarBtn = UIBarButtonItem(customView: rightBtn)
        navigationItem.rightBarButtonItems = [negativeSpacer, rightBarBtn]
        
        setupNavigationForBackBtn()
    }
    
    func setupNavigationForBackBtn() {
        if navigationController == nil {
            return
        }
        
        let stackCount = navigationController!.viewControllers.count - 2
        if stackCount >= 0 {
            navigationController!.navigationBar.tintColor = UIColor.whiteColor()
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
