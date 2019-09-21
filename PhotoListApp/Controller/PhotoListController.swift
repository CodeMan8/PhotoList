//
//  PhotoListController.swift
//  PhotoListApp
//
//  Created by Bartu akman on 25.06.2019.
//  Copyright © 2019 Bartu akman. All rights reserved.
//

import UIKit
import Photos
 

private let reuseIdentifier = "cell"

class PhotoListController: UIViewController {
    
 //outlets
    @IBOutlet weak var collectionview: UICollectionView!
    
   static var delete: Bool = false
    static var  row: Int = 0
 
    var albumname: String = ""{
        didSet{
            fetchPhotos(name: albumname)
        }
    }
     var images:[UIImage] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if PhotoListController.delete == true {
            PhotoListController.delete = false
            if albumname == "All" {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
                PHPhotoLibrary.shared().performChanges( {
                    let imageAssetToDelete = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions).object(at: PhotoListController.row)
                    PHAssetChangeRequest.deleteAssets([imageAssetToDelete] as NSArray)
                },
                                                        completionHandler: { success, error in
                                                            
                                                            if success {
                                                                DispatchQueue.main.async {
                                                                    self.images.remove(at: PhotoListController.row)
                                                                    self.collectionview.reloadData()
                                                                }
                                                                
                                                            }
                                                            print("Finished deleting asset. %@", (success ? "Success" : error))
                                                            
                })
            }
            else {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@",albumname)
                
                
                
                
                PHPhotoLibrary.shared().performChanges( {
                    let collection =     PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: fetchOptions).firstObject
                    let imageAssetToDelete = PHAsset.fetchAssets(in: collection!, options: nil).object(at: PhotoListController.row)

 
                    
                    PHAssetChangeRequest.deleteAssets([imageAssetToDelete] as NSArray)
                },
                                                        completionHandler: { success, error in
                                                            
                                                            if success {
                                                                DispatchQueue.main.async {
                                                                    self.images.remove(at: PhotoListController.row)
                                                                    self.collectionview.reloadData()
                                                                }
                                                                
                                                            }
                                                            print("Finished deleting asset. %@", (success ? "Success" : error))
                                                            
                })
            }

 
            
 
 
        
            
        }
    }
     override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionview.delegate = self
        collectionview.dataSource = self
 
    }

    func fetchPhotos (name: String) {
        
        
        if name == "All" {
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
              let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
 
            let count =  fetchResult.count
            fetchOptions.fetchLimit = count
            if fetchResult.count > 0 {
                let totalImageCountNeeded = count+1 // <-- The number of images to fetch
                fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
 
            }

        }
            
        else {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@",albumname)
            
            let collection =     PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: fetchOptions).firstObject
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection!, options: nil)
            let count =  fetchResult.count
            fetchOptions.fetchLimit = count
            
            if fetchResult.count > 0 {
                let totalImageCountNeeded = count+1 // <-- The number of images to fetch
                fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
            }
 
        }
        
       
    
        
        
       
    }
    
    func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {
       
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
         // Perform the image request
        PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
            if let image = image {
 
                
                // Add the returned image to your array
                
                 self.images += [image]
                DispatchQueue.main.async {
                    self.collectionview.reloadData()

                }
            }
            
            
            if index + 1 < fetchResult.count && self.images.count < totalImageCountNeeded {
                self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
            } else {
                // Else you have completed creating your array
                print("Completed array: \(self.images)")
            }
        })
    }

     // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "godetail" {
            
            if let dest = segue.destination as? PhotoDetailController{
                
                if let data = sender as? UIImage {
                    print(data)
                     dest.image = data
 
                }
                
            }
        }
        
        
     }
    

    
 

}
extension PhotoListController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoListCell
             let mycell = images[indexPath.row]
            cell.updateUI(name: mycell)
            
            return cell
            
        
        
 
     }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        PhotoListController.row = indexPath.row
        let mycell = images[indexPath.row]
        performSegue(withIdentifier: "godetail", sender: mycell)
        
 

    }
}

extension PhotoListController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        
            
            let size = collectionview.frame.size
            return CGSize(width: size.width/4, height: size.height/7)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
}
}
