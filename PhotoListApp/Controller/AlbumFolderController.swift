//
//  ViewController.swift
//  PhotoListApp
//
//  Created by Bartu akman on 25.06.2019.
//  Copyright © 2019 Bartu akman. All rights reserved.
//

import UIKit
import Photos
 
protocol MyCustomCellDelegator {
    func callSegueFromCell(data: String)
}
class AlbumFolderController: UIViewController {
    
    
    static var name: String = ""
    
 
    @IBOutlet weak var collectionview: UICollectionView!
    var images = [UIImage]()
    
    var imagesCount = 0
    
    var names = [String]()
    
 
     override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionview.delegate = self
        collectionview.dataSource = self
        
      getAlbumNames()
        
        
  
        
 
    }
    
    
    @IBAction func AllButtonClicked(_ sender: UIButton) {
        AlbumFolderController.name = "All"
        performSegue(withIdentifier: "goto", sender: nil)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goto" {
            
            if  let dest = segue.destination as? PhotoListController {
                
                dest.albumname =  AlbumFolderController.name
 
                
            }
        }
    }
    
    func fetchPhotos (name: String) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@",name)
        
        let collection =     PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: fetchOptions).firstObject
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection!, options: nil)
        let count =  fetchResult.count
        fetchOptions.fetchLimit = count
        
        if fetchResult.count > 0 {
            let totalImageCountNeeded = count+1
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
        }
    }
 
    func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        // Perform the image request
        PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
            if let image = image {
                
                self.images.append(image)

 
            }
            
            
            
        })
    }
    func getAlbumNames(){
        
        let userAlbumsOptions = PHFetchOptions()
        userAlbumsOptions.predicate = NSPredicate(format: "estimatedAssetCount>0")
        
        
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: userAlbumsOptions)
        
        imagesCount = userAlbums.count
        print(userAlbums.count)
         print("aradaıgım yer")
        
        for index in 0...userAlbums.count-1  {
            
            let album = userAlbums.object(at: index)
            print(album.localizedTitle)
            names.append(album.localizedTitle!)
             fetchPhotos(name: album.localizedTitle!)
 
        }
        
 
        
     }
    
    
   
    
    
    
   


}
extension AlbumFolderController: UICollectionViewDataSource,UICollectionViewDelegate,MyCustomCellDelegator {
    
    func callSegueFromCell(data: String) {
        
        self.performSegue(withIdentifier: data, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return imagesCount
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "albumcell", for: indexPath) as! AlbumFolderCell
        
        cell.delegate = self
 
        let mycell = names[indexPath.row]
        let secondcell = images[indexPath.row]
         cell.updateUI(name:mycell)
        cell.imageview.image = secondcell
 
        
 
        
        
        
        
        return cell

        
        
    }
 
    
    
}

