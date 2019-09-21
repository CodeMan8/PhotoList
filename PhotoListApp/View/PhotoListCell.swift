//
//  PhotoListCell.swift
//  PhotoListApp
//
//  Created by Bartu akman on 25.06.2019.
//  Copyright © 2019 Bartu akman. All rights reserved.
//

import UIKit

class PhotoListCell: UICollectionViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    func updateUI(name: UIImage) {
        DispatchQueue.main.async {
            self.imageview.image = name

        }
        
        
        
    }

}
