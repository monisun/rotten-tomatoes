//
//  MovieCollectionViewCell.swift
//  RottenTomatoes
//
//  Created by Monica Sun on 5/11/15.
//  Copyright (c) 2015 Monica Sun. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selected = false
    }
    
}
