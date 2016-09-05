//
//  CategoriesViewCell.swift
//  ClickTest
//
//  Created by Jhon Villalobos on 9/4/16.
//  Copyright © 2016 Jhon Villalobos. All rights reserved.
//

import UIKit

class CategoriesViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var titleCategory: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
