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
    
    @IBOutlet weak var tableView: UITableView!
    
    var offsetHeaderViewStop: CGFloat!
    var offsetHeader: CGFloat?
    var offsetHeaderBackgroundViewStop: CGFloat!
    var offsetNavigationLabelViewStop: CGFloat!
    var navigationBarHeight: CGFloat!
    
    var ifTweet: Bool = true
    var pan: UIPanGestureRecognizer!
    var offset: Int? = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        networkCall()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        if user != nil {
            nameLabel.text = user!.name as? String
            handleLabel.text = "@\(user!.screenname as! String)"
            taglineLabel.text = user!.tagline as? String
            followingCountLabel.text = "\(user!.followingCount!)"
            followersCountLabel.text = "\(user!.followersCount!)"
            
            profileImageView.setImageWithURL(user!.profileUrlHigh!)
            
            if user!.profileBannerImage != nil {
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
        offsetHeaderViewStop = tweetsSegmentControl.frame.origin.y - navigationBarHeight - 8
        offsetHeaderBackgroundViewStop = (headerBackground.frame.size.height + headerBackground.frame.origin.y) - navigationBarHeight
        offsetNavigationLabelViewStop = hiddenNameLabel.frame.origin.y - (navigationBarHeight / 2) + 8
        headerBackground.clipsToBounds = true
        lineHeightConstraint.constant = 1 / UIScreen.mainScreen().scale
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as! TimelineCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
