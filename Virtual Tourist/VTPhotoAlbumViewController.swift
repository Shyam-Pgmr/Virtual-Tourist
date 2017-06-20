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

    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: Helpers
    
    func setupView() {
        
        addPinIntoMapView()
        focusPin()
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
    
}
