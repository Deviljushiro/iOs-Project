//
//  InfoTableViewCell.swift
//  iOs-Project
//
//  Created by JeanMi on 24/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var url: UITextView!
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var sentDate: UILabel!
    
    
    //MARK: - Cell methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
