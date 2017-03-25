//
//  ListGroupTableViewCell.swift
//  iOs-Project
//
//  Created by Julien GALLEGO on 22/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class ListGroupTableViewCell: UITableViewCell {

    //Mark: - Outlets
    
    @IBOutlet weak var group: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Cell methods
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
