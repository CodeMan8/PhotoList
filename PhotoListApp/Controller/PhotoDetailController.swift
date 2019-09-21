//
//  PhotoDetailController.swift
//  PhotoListApp
//
//  Created by Bartu akman on 25.06.2019.
//  Copyright © 2019 Bartu akman. All rights reserved.
//

import UIKit

class PhotoDetailController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
    }
     var image: UIImage?
 
   
    
    @IBOutlet weak var imageview: UIImageView!{
        
        didSet{
            DispatchQueue.main.async {
                self.imageview.image = self.image
                self.imageSizeLabel.text = String(describing: self.image!.size)
                self.imagedetailname.text = self.image!.debugDescription
            }
          
        }
    }
    
    @IBOutlet weak var imageSizeLabel: UILabel!
    @IBOutlet weak var imagedetailname: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        
          self.navigationController?.popViewController(animated: true)
 
         PhotoListController.delete = true
        
        
        

     }
    
    
    
 
    

}
