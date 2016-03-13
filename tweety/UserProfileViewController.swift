//
//  UserProfileViewController.swift
//  tweety
//
//  Created by Gale on 3/1/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: User!
    var tweets = [Tweet]()
    
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headerBannerImageView: UIImageView!
    @IBOutlet weak var blurBannerImageView: UIImageView!
    @IBOutlet weak var headerBackground: UIView!
    @IBOutlet weak var hiddenNameLabel: UILabel!
    @IBOutlet weak var numberOfLabel: UILabel!

    @IBOutlet weak var profileImageTopMargin: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var offsetHeaderViewStop: CGFloat!
    var offsetHeader: CGFloat?
    var offsetHeaderBackgroundViewStop: CGFloat!
    var offsetNavigationLabelViewStop: CGFloat!
    var navigationBarHeight: CGFloat!
    var initialOffset: CGFloat? = nil
    
    var ifTweet: Bool = true
    var offset: Int? = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //tableView.tableHeaderView = headerView
        tableView.dataSource = self
        tableView.delegate = self
        
        networkCall()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        if user != nil {
            
            profileImageView.setImageWithURL(user!.profileUrlHigh!)
            
            if user!.profileBannerImage != nil {
                hiddenNameLabel.text = user!.name as? String
                numberOfLabel.text = "\(user!.statusesCount!) of Tweets"
                headerBannerImageView.setImageWithURLRequest(NSURLRequest(URL: user!.profileBannerImage!), placeholderImage: nil, success: { (request, response, image) -> Void in
                    self.headerBannerImageView.image = image

                    }) { (request, response, error) -> Void in
                    print(error.localizedDescription)
                }
            } else {
                if user!.profileBackgroundImage != nil {
                    headerBannerImageView.setImageWithURLRequest(NSURLRequest(URL: user!.profileBackgroundImage!), placeholderImage: nil, success: { (request, response, image) -> Void in
                        self.headerBannerImageView.image = image
                        
                        
                        }) { (request, response, error) -> Void in
                            print(error.localizedDescription)
                    }
                }
            }
        }
        
        // Hiding labels for the navigation bar
        hiddenNameLabel.hidden = true
        numberOfLabel.hidden = true
        
        // Making sure header image does not overflow
        navigationBarHeight = navigationController!.navigationBar.frame.size.height + navigationController!.navigationBar.frame.origin.y
        offsetHeaderViewStop = tableView.frame.origin.x - navigationBarHeight - 8
        offsetHeaderBackgroundViewStop = (headerBackground.frame.size.height + headerBackground.frame.origin.y) - navigationBarHeight
        offsetNavigationLabelViewStop = hiddenNameLabel.frame.origin.y - (navigationBarHeight / 2) + 8
        headerBackground.clipsToBounds = true
        
        // Profile image white border border & positioning
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.borderWidth = 4.0
        profileImageTopMargin.constant = navigationBarHeight + 4.0
        profileImageView.layer.zPosition = 1
        
        // Making navbar see-through
        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.translucent = true;
        navigationController!.view.backgroundColor = UIColor.clearColor()
        navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
        
        UINavigationBar.appearance().layer.shadowOffset = CGSizeMake(0, 0)
        UINavigationBar.appearance().layer.shadowRadius = 0.0
        UINavigationBar.appearance().layer.shadowColor = UIColor.clearColor().CGColor
        UINavigationBar.appearance().layer.shadowOpacity = 0.0
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController!.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        // Back to previous version
        UINavigationBar.appearance().layer.shadowOffset = CGSizeMake(0, 2)
        UINavigationBar.appearance().layer.shadowRadius = 1.0
        UINavigationBar.appearance().layer.shadowColor = UIColor.lightGrayColor().CGColor
        UINavigationBar.appearance().layer.shadowOpacity = 0.7
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell") as! ProfileCell
            cell.nameLabel.text = user!.name as? String
            cell.handleLabel.text = "@\(user!.screenname as! String)"
            cell.taglineLabel.text = user!.tagline as? String
            cell.followingCountLabel.text = "\(user!.followingCount!) Following"
            cell.followersCountLabel.text = "\(user!.followersCount!) Followers"
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as! TimelineCell
            cell.tweet = tweets[indexPath.row]
        
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Network Calls
    
    func networkCall() {
        var apiParameters : [String: Int] {
            get {
                return ["user_id": user.id!, "count": offset!]
            }
        }
        
        TwitterClient.sharedInstance.fetchingUserTimeline(apiParameters, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()

            
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)

        })

    }
    
    // I received a lot of help with this & read & understood someone else code to achieve this
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Setting starting offset (in the event the view was already scrolled)
        if initialOffset == nil {
            initialOffset = scrollView.contentOffset.y
        }
        
        let offset = scrollView.contentOffset.y - initialOffset!
        offsetHeader = max(-offsetHeaderViewStop, -offset)
        
        // Changing header banner height and scale
        var headerBackgroundTransform = CATransform3DIdentity
        var profileImageTransform = CATransform3DIdentity
        
        if offset < 0 {
            let headerImageScaleFactor = (-offset) / headerBackground.bounds.height
            let headerImageHeightChanged = headerImageScaleFactor * headerBackground.bounds.height / 2.0
            headerBackgroundTransform = CATransform3DTranslate(headerBackgroundTransform, 0, headerImageHeightChanged, 0)
            headerBackgroundTransform = CATransform3DScale(headerBackgroundTransform, 1.0 + headerImageScaleFactor, 1.0 + headerImageScaleFactor, 0)
            
            profileImageTransform = CATransform3DTranslate(profileImageTransform, 0, -offset, 0)
            hiddenNameLabel.hidden = true
            numberOfLabel.hidden = true
            
        } else {
            headerBackgroundTransform = CATransform3DTranslate(headerBackgroundTransform, 0, max(-offsetHeaderBackgroundViewStop, -offset), 0)
            
            let profileImageScaleFactor = (min(offsetHeaderBackgroundViewStop, offset)) / profileImageView.bounds.height / 1.4
            let profileImageHeightChanged = profileImageView.bounds.height * profileImageScaleFactor
            profileImageTransform = CATransform3DScale(profileImageTransform, 1.0 - profileImageScaleFactor, 1.0 - profileImageScaleFactor, 0)
            
            var profileImageYTranslation = profileImageHeightChanged
            if offset > offsetHeaderBackgroundViewStop {
                profileImageYTranslation += (offset - offsetHeaderBackgroundViewStop) * 1.5
            }
            profileImageTransform = CATransform3DTranslate(profileImageTransform, 0, -profileImageYTranslation, 0)
        }
        
        headerBackground.layer.transform = headerBackgroundTransform
        
        if offset >= 126 {
            hiddenNameLabel.hidden = false
            numberOfLabel.hidden = false
        }
        
        let labelTransform = CATransform3DMakeTranslation(0, max(-offsetNavigationLabelViewStop, -offset), 0)
        hiddenNameLabel.layer.transform = labelTransform
        numberOfLabel.layer.transform = labelTransform
        
        
        profileImageView.layer.transform = profileImageTransform
        
        
        if offset <= offsetHeaderBackgroundViewStop {
            
            if profileImageView.layer.zPosition < headerBackground.layer.zPosition{
                headerBackground.layer.zPosition = profileImageView.layer.zPosition - 1
                hiddenNameLabel.layer.zPosition = headerBackground.layer.zPosition
                numberOfLabel.layer.zPosition = headerBackground.layer.zPosition
            }
            
        } else {
            
            if profileImageView.layer.zPosition >= headerBackground.layer.zPosition{
                headerBackground.layer.zPosition = profileImageView.layer.zPosition + 1
                hiddenNameLabel.layer.zPosition = headerBackground.layer.zPosition + 1
                numberOfLabel.layer.zPosition =
                    headerBackground.layer.zPosition + 1
            }
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
