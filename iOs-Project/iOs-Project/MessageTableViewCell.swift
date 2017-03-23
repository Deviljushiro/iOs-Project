//
//  MessageTableViewCell.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 08/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var sendDate: UILabel!
    @IBOutlet weak var senderPic: UIImageView!
    @IBOutlet weak var msgImage: UIImageView!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var username: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    
}
