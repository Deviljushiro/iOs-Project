
//
//  CalendatEventTableViewCell.swift
//  iOs-Project
//
//  Created by JeanMi on 26/03/2017.
//  Copyright © 2017 Jean MIQUEL. All rights reserved.
//

import UIKit

class CalendarEventTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventStart: UILabel!
    @IBOutlet weak var eventEnd: UILabel!
    @IBOutlet weak var eventBody: UITextView!
    
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
