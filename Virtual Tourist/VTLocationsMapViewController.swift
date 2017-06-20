//
//  VTLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Shyam on 19/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit
import MapKit

class VTLocationsMapViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var mapView:MKMapView!
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: Action
    
    @IBAction func longPressGestureOnMapView(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            let touchPoint = sender.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            storePin(using: newCoordinates)
            fetchStoredPinsAndAddIntoMap()
        }
    }
    
    // MARK: Helpers
    
    func setupView() {
        
        showMapViewLastRegion()
        fetchStoredPinsAndAddIntoMap()
    }
    
    func showMapViewLastRegion() {
        
        let lastRegion = UserDefaults.getMapViewLastRegion()
        
        if lastRegion.center.latitude != 0 && lastRegion.center.longitude != 0 {
            
            mapView.setRegion(lastRegion, animated: true)
        }
    }
    
    func fetchStoredPinsAndAddIntoMap() {
        
        removeAllPinsFromMap()

        let pinsArray = CoreDataManager.shard().getPins()
        for pin in pinsArray {
            
            addAnnotation(using: pin)
        }
    }
    
    func removeAllPinsFromMap() {
        
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
    }
    
    func addAnnotation(using pin:Pin) {
        
        let annotation = CustomPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        annotation.pin = pin
        mapView.addAnnotation(annotation)
    }
    
    func storePin(using coordinates:CLLocationCoordinate2D) {
        
        CoreDataManager.shard().storePin(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    func showPhotoAlbum(using pin:Pin?) {
        
        if let photoAlbumController = self.storyboard?.instantiateViewController(withIdentifier: Constant.Storyboard.ViewController.PhotoAlbum) as? VTPhotoAlbumViewController {
            
            photoAlbumController.pin = pin
            navigationController?.pushViewController(photoAlbumController, animated: true)
        }
    }
}

extension VTLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // Presist MapView's region
        UserDefaults.setMapView(last: mapView.region)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let pointAnnotation = view.annotation as? CustomPointAnnotation {
            showPhotoAlbum(using: pointAnnotation.pin)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PinAnnotation")
        pinAnnotation.pinTintColor = .red;
        pinAnnotation.animatesDrop = true;
        pinAnnotation.canShowCallout = false;
        pinAnnotation.setSelected(true, animated: true)
        
        return pinAnnotation
    }

}

class CustomPointAnnotation:MKPointAnnotation {
    
    var pin:Pin?
    
    override init() {
        super.init()
    }
    
}
