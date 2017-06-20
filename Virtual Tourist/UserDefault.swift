//
//  UserDefault.swift
//  Virtual Tourist
//
//  Created by Shyam on 20/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import MapKit

extension UserDefaults {
    
    struct Keys {
        static let LastMapViewLatitude = "Last MapView Latitude"
        static let LastMapViewLongitude = "Last MapView Longitude"
        static let LastMapViewLatitudeDelta = "Last MapView Latitude Delta"
        static let LastMapViewLongitudeDelta = "Last MapView Longitude Delta"
    }
    
    private class var defaults:UserDefaults {
        return UserDefaults.standard
    }
    
    class func setMapView(last region:MKCoordinateRegion) {
        
        // Store Center Point
        defaults.set(region.center.latitude, forKey: Keys.LastMapViewLatitude)
        defaults.set(region.center.longitude, forKey: Keys.LastMapViewLongitude)
        
        // Store Span
        defaults.set(region.span.latitudeDelta, forKey: Keys.LastMapViewLatitudeDelta)
        defaults.set(region.span.longitudeDelta, forKey: Keys.LastMapViewLongitudeDelta)
        
        defaults.synchronize()
    }
    
    class func getMapViewLastRegion() -> MKCoordinateRegion {
        
        let center = CLLocationCoordinate2D(latitude: defaults.double(forKey: Keys.LastMapViewLatitude), longitude: defaults.double(forKey: Keys.LastMapViewLongitude))
        let span = MKCoordinateSpan(latitudeDelta: defaults.double(forKey: Keys.LastMapViewLatitudeDelta), longitudeDelta: defaults.double(forKey: Keys.LastMapViewLongitudeDelta))
        
        let region = MKCoordinateRegion(center: center, span: span)
        return region
    }
    
}
