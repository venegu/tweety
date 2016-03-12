//
//  ProfileCell.swift
//  tweety
//
//  Created by Gale on 3/11/16.
//  Copyright © 2016 Gale. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User! {
        didSet {
            nameLabel.text = user!.name as? String
            handleLabel.text = "@\(user!.screenname as! String)"
            taglineLabel.text = user!.tagline as? String
            followingCountLabel.text = "\(user!.followingCount!) Following"
            followersCountLabel.text = "\(user!.followersCount!) Followers"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
