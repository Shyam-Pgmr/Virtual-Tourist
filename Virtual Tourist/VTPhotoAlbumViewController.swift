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
    
    var pin:Pin?

    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
