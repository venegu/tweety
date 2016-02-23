//
//  TimelineCell.swift
//  tweety
//
//  Created by Gale on 2/21/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoritedCount: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var didRetweet: Bool = false
    var didFavorite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        retweetCount.text = ""
        favoritedCount.text = ""
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onReply(sender: AnyObject) {
    }
    

    @IBAction func onRetweet(sender: AnyObject) {
        
    }
    
    
    @IBAction func onFavorite(sender: AnyObject) {
    }

}
