//
//  ListTableViewCell.swift
//  iOs-Project
//
//  Created by Jean MIQUEL on 13/02/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    // MARK : - Outlets
    
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var prenom: UILabel!
    
    // MARK: - Cell methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
