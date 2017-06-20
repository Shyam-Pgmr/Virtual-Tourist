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

    // MARK: Action
    
    @IBAction func longPressGestureOnMapView(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            
            let touchPoint = sender.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            addAnnotation(at: newCoordinates)
        }
    }
    
    // MARK: Helpers
    
    func addAnnotation(at coordinates:CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }

}

extension VTLocationsMapViewController: MKMapViewDelegate {
    
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
