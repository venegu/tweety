//
//  TweetsViewController.swift
//  tweety
//
//  Created by Gale on 2/21/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkAlert: UIView!
    
    
    var tweets = [Tweet]()
    
    // Declaring variables pertaining to infinite scrolling
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var offset: Int? = 20
    var tweetIdLast : Int = 0
    var tweetIdArray : [Int] = []
    
    var apiParameters : [String: Int] {
        get {
            return ["max_id": tweetIdLast, "count": offset!]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkAlert.hidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        /* For dynamically sized cells - Auto layout */
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        networkCall()
        
        // Adding loading view as an inset to the table view for infinite scrolling
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Defining tap gesture for network alert view
        let networkTap = UITapGestureRecognizer()
        networkTap.addTarget(self, action: "handleTap")
        self.networkAlert.addGestureRecognizer(networkTap)
        
        // Do any additional setup after loading the view.
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
        tweetIdLast = tweets[indexPath.row].tweetId
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
   // MARK: - Button Actions
    
    /* Logout Button */
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func handleTap () {
        networkCall()
    }
    
    
    // Checking if the user scrolled, making the request/view and starting the load indicator
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadData()
            }
        }
    }
    
    @IBAction func onImageClick(sender: AnyObject) {
        let url = sender.image
        print(url)
    }
    
    // MARK: - Network Calls
    
    func loadData() {
        TwitterClient.sharedInstance.homeTimeline(apiParameters, success: { (tweets: [Tweet]) -> () in
            self.loadingMoreView!.stopAnimating()
            
            if tweets != [] {
                for tweet in tweets {
                    self.tweets.append(tweet)
                }
            }
            self.hideNetworkAlert()
            
            self.tableView.reloadData()
            self.offset = self.offset! + 20
            self.isMoreDataLoading = false
        }, failure: {(error: NSError) -> () in
                print(error.localizedDescription)
                self.showNetworkAlert()
        })
       
    }
    
    func networkCall() {
        TwitterClient.sharedInstance.homeTimeline(nil, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.hideNetworkAlert()

            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
                self.showNetworkAlert()
        })
        
    }
    
    // MARK: - Network Error Functions
    
    // Delay to hide network error
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    // Animating network error
    func showNetworkAlert() {
        self.networkAlert.alpha = 0.0
        self.networkAlert.hidden = false
        
        UIView.animateWithDuration(0.5, animations: {
            self.networkAlert.alpha = 1.0
        })
    }
    
    func hideNetworkAlert() {
        if(self.networkAlert.hidden == false) {
            UIView.animateWithDuration(0.5, animations: {
                self.networkAlert.alpha = 0.0
            })
            
            runAfterDelay(0.5, block: {
                self.networkAlert.hidden = true
            })
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        networkCall()
        refreshControl.endRefreshing()
    }
   
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        
        if segue.identifier == "toTweetDetailView" {
            let tweetDetailViewController: TweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
            let cell = sender as! TimelineCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets[(indexPath?.row)!]
            tweetDetailViewController.tweet = tweet
        }
        
        if (segue.identifier == "toReplyToTweet") {
            let button = sender as! UIButton
            let buttonFrame = button.convertRect(button.bounds, toView: self.tableView)
            if let indexPath = self.tableView.indexPathForRowAtPoint(buttonFrame.origin) {
                let nav = segue.destinationViewController as! UINavigationController
                let replyTweetViewController = nav.topViewController as! ReplyTweetViewController
                let tweet = tweets[(indexPath.row)]
                replyTweetViewController.replyTo = tweet
            }
        }
    }
}

// MARK: - Infinite Scroll Class

class InfiniteScrollActivityView: UIView {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.activityIndicatorViewStyle = .Gray
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.hidden = true
    }
    
    func startAnimating() {
        self.hidden = false
        self.activityIndicatorView.startAnimating()
    }
}