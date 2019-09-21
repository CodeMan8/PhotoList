//
//  AlbumFolderCell.swift
//  PhotoListApp
//
//  Created by Bartu akman on 25.06.2019.
//  Copyright © 2019 Bartu akman. All rights reserved.
//

import UIKit
import Photos

class AlbumFolderCell: UICollectionViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var albumname: UILabel!
    
    var delegate:MyCustomCellDelegator!

 
 
    
    
    func updateUI(name: String) {
        
        let tapGesture = UITapGestureRecognizer (target: self, action: #selector(imgTap(tapGesture:)))
        tapGesture.numberOfTapsRequired = 1
        imageview?.isUserInteractionEnabled = true
        imageview?.addGestureRecognizer(tapGesture)
        
        DispatchQueue.main.async {
            
            self.albumname.text = name
           
 
 
 
            
 

         }
     

 
        
        
    }
    @objc func imgTap(tapGesture: UITapGestureRecognizer) {
        
         AlbumFolderController.name = albumname.text!
        
        let mydata = "goto"
        if(self.delegate != nil){
            self.delegate.callSegueFromCell(data: mydata)
        }
        
 
        
        
 
       
 
    }
    
    
}
