//
//  TeamListTableViewCell.swift
//  MetroRetro
//
//  Created by Terell Pigram on 4/8/18.
//  Copyright © 2018 Terell Pigram. All rights reserved.
//

import UIKit

class TeamListTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var teamDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
