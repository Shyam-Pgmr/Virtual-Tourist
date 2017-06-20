//
//  VTPhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Shyam on 20/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class VTPhotoAlbumViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var loaderView:UIView!
    @IBOutlet weak var noImageLabel:UILabel!
    @IBOutlet weak var newCollectionButton:UIButton!
    
    // MARK: Properties
    
    var pin:Pin!
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            fetchedResultsController?.delegate = self
            loadPhotos()
            collectionView.reloadData()
        }
    }
    let ItemSpacing:CGFloat = 10.0
    let PhotoCellIdentifier = "VTPhotoCollectionViewCell"
    var blockOperations: [BlockOperation] = []
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    deinit {
        cancelAllBlockOperations()
    }

    // MARK: Action

    @IBAction func newCollectionButtonTapAction(_ sender:UIButton) {
        
        
    }
    
    // MARK: Helpers
    
    func setupView() {
        
        navigationController?.navigationBar.backItem?.title = "Back"
        
        addPinIntoMapView()
        focusPin()
        
        setupFetchRequestController()
        fetchPhotosFromFlickrIfRequired()
    }
    
    func setupFetchRequestController() {
        
        fetchedResultsController = CoreDataManager.shard().getFetchRequestControllerForPhotos(pin: pin)
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
        
        if let fc = fetchedResultsController {
            do {
               try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to fetch a photo: \n\(e)\n\(String(describing: fetchedResultsController))")
            }
        }
    }
    
    func cancelAllBlockOperations() {
        for operation in blockOperations {
            operation.cancel()
        }
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    // MARK: API
    
    func fetchPhotosFromFlickrIfRequired() {
        guard fetchedResultsController?.sections?.count == 0 else {
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

// MARK: CollectionView Datasource, Delegate

extension VTPhotoAlbumViewController:UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let fc = fetchedResultsController {
            return (fc.sections?.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let fc = fetchedResultsController {
            return fc.sections![section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = fetchedResultsController?.object(at: indexPath) as! Photo
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCellIdentifier, for: indexPath) as! VTPhotoCollectionViewCell
        cell.setupCell(photo: photo)
        return cell
    }
    
}

extension VTPhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let dimension = (collectionView.frame.width - (ItemSpacing * (itemsPerRow - 1))) / itemsPerRow
        return CGSize(width: dimension, height: dimension)
    }
    
}

// MARK: NSFetchedResultsController Delegate

extension VTPhotoAlbumViewController:NSFetchedResultsControllerDelegate {
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let set = IndexSet(integer: sectionIndex)
        
        switch (type) {
        case .insert:
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView.insertSections(set)
                    }
                })
            )
        case .delete:
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView.deleteSections(set)
                    }
                })
            )
        default:
            // irrelevant in our case
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView.insertItems(at: [newIndexPath!])
                    }
                })
            )
        case .delete:
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView.deleteItems(at: [indexPath!])
                    }
                })
            )
        case .update:
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView.reloadItems(at: [indexPath!])
                    }
                })
            )
        case .move:
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView.deleteItems(at: [indexPath!])
                        this.collectionView.insertItems(at: [newIndexPath!])
                    }
                })
            )
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({ () -> Void in
            for operation in self.blockOperations {
                operation.start()
            }
        }, completion: { (finished) -> Void in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
    
}
