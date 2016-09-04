//
//  MainTableViewCell.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/1/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rank1: UIImageView!
    @IBOutlet weak var rank2: UIImageView!
    @IBOutlet weak var rank3: UIImageView!
    @IBOutlet weak var rank4: UIImageView!
    @IBOutlet weak var rank5: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var kmLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
