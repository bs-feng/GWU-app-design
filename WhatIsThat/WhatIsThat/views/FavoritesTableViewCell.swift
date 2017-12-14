//
//  FavoritesTableViewCell.swift
//  WhatIsThat
//
//  Created by Baosheng Feng on 12/13/17.
//  Copyright © 2017 gwu. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {


    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
