//
//  RetrospcectiveCollectionViewCell.swift
//  MetroRetro
//
//  Created by Derell Pigram on 11/12/17.
//  Copyright © 2017 Terell Pigram. All rights reserved.
//

import UIKit

class RetrospcectiveCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var retoDescription: UILabel!
    @IBOutlet weak var numberOfItems: UILabel!
    @IBOutlet weak var footerBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        numberOfItems.textColor = UIColor.black
        self.layer.cornerRadius = 6
        self.backgroundColor = UIColor(red: 235/255, green: 245/255, blue: 255/255, alpha: 1.0)
        self.footerBackground.backgroundColor = UIColor(red: 228/255, green: 237/255, blue: 247/255, alpha: 1.0)
    }

    
}
