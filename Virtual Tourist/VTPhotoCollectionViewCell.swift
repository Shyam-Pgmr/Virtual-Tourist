//
//  VTPhotoCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Shyam on 20/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

class VTPhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    // MARK: Properties
    
    var imageTask:URLSessionDataTask?
    
    // MARK: Helpers
    
    func cancelAnyExistingTask() {
        if let imageTask = imageTask {
            imageTask.cancel()
            self.imageTask = nil
        }
    }
    
    func setupCell(photo:Photo) {
        imageView.image = nil // Clear any existing image
        cancelAnyExistingTask()
        loadImageInBackground(urlString: photo.imageURL)
    }
    
    func loadImageInBackground(urlString:String?) {
        activityIndicator.startAnimating()
        if let imageURL = urlString, let url = URL(string:imageURL) {
            
            // Download image and Cache it 
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
            self.imageTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data else {
                    print("Error in loading Image URL")
                    return
                }
                Utility.runOnMain {
                    self.imageView.image = UIImage(data: data)
                    self.activityIndicator.stopAnimating()
                }
            })
            self.imageTask?.resume()
        }
    }
}
