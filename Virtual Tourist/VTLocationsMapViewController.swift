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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showMapViewLastRegion()
        fetchStoredPinsAndAddIntoMap()
    }
    
    // MARK: Action
    
    @IBAction func longPressGestureOnMapView(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            let touchPoint = sender.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            addAnnotation(at: newCoordinates)
            storePin(using: newCoordinates)
        }
    }
    
    // MARK: Helpers
    
    func showMapViewLastRegion() {
        
        let lastRegion = UserDefaults.getMapViewLastRegion()
        
        if lastRegion.center.latitude != 0 && lastRegion.center.longitude != 0 {
            
            mapView.setRegion(lastRegion, animated: true)
        }
    }
    
    func fetchStoredPinsAndAddIntoMap() {
        
        let pinsArray = CoreDataManager.shard().getPins()
        
        for pin in pinsArray {
            let coordinates = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            addAnnotation(at: coordinates)
        }
    }
    
    func addAnnotation(at coordinates:CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }

    func storePin(using coordinates:CLLocationCoordinate2D) {
        
        CoreDataManager.shard().storePin(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
}

extension VTLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // Presist MapView's region
        UserDefaults.setMapView(last: mapView.region)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped")
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
