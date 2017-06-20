//
//  VTPhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Shyam on 20/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit
import MapKit

class VTPhotoAlbumViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var collectionView:UICollectionView!
    
    // MARK: Properties
    
    var pin:Pin!
    var photoCollections:[Photo]!
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: Helpers
    
    func setupView() {
        
        addPinIntoMapView()
        focusPin()
        
        photoCollections = CoreDataManager.shard().getPhoto(of: pin)
        fetchPhotosFromFlickrIfRequired()
    }
    
    func addPinIntoMapView() {
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        mapView.addAnnotation(pointAnnotation)
    }
    
    func focusPin() {
        
        let center = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
 
    func loadPhotos() {
        
    }
    
    // MARK: API
    
    func fetchPhotosFromFlickrIfRequired() {
        guard photoCollections.count == 0 else {
            loadPhotos()
            return
        }
        fetchPhotoFromFlickr()
    }
    
    func fetchPhotoFromFlickr() {
        
        let _ = VTAPIManager.shared().getImages(forLatitude: pin.latitude, longitude: pin.longitude) { (result, errorMessage) in
            
            func displayError(_ message:String) {
                Utility.Alert.show(title: Constant.Alert.Title.Oops, message: message, viewController: self, handler: { (action) in
                })
            }
            
            func cachePhotos(photosArray:[[String:AnyObject]]) {
                CoreDataManager.shard().storePhotos(using: photosArray, pin: self.pin)
            }
            
            guard let result = result else {
                displayError(errorMessage!)
                return
            }
            
            // Did Flickr return an error (stat != ok)?
            guard let stat = result[FlickrClient.ResponseKeys.Status] as? String, stat == FlickrClient.ResponseValues.OKStatus else {
                displayError("Flickr API returned an error. See error code and message in \(result)")
                return
            }
            
            // Is "photos" key in our result?
            guard let photosDictionary = result[FlickrClient.ResponseKeys.Photos] as? [String:AnyObject] else {
                displayError("Cannot find keys '\(FlickrClient.ResponseKeys.Photos)' in \(result)")
                return
            }
            
            // Is the "photo" key in photosDictionary?
            guard let photosArray = photosDictionary[FlickrClient.ResponseKeys.Photo] as? [[String: AnyObject]] else {
                displayError("Cannot find key '\(FlickrClient.ResponseKeys.Photo)' in \(photosDictionary)")
                return
            }
            
            if photosArray.count == 0 {
                displayError("No Photos Found")
                return
            }
            else {
                cachePhotos(photosArray: photosArray)
                
                Utility.runOnMain {
                    self.loadPhotos()
                }
            }
        }
    }
}
