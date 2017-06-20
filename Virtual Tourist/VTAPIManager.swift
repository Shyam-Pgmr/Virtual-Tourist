//
//  VTAPIManager.swift
//  Virtual Tourist
//
//  Created by Shyam on 19/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

class VTAPIManager: NSObject {

    
    // MARK: Flickr APIs
    
    func getImages(forLatitude latitude:Double, longitude:Double, completionHandler:@escaping (_ response:AnyObject?,_ error:String?)->Void) -> URLSessionDataTask {
        
        let methodParameters = [
            FlickrClient.ParameterKeys.Method: FlickrClient.ParameterValues.SearchMethod,
            FlickrClient.ParameterKeys.APIKey: FlickrClient.ParameterValues.APIKey,
            FlickrClient.ParameterKeys.Latitude: latitude,
            FlickrClient.ParameterKeys.Longitude: longitude,
            FlickrClient.ParameterKeys.SafeSearch: FlickrClient.ParameterValues.UseSafeSearch,
            FlickrClient.ParameterKeys.Extras: FlickrClient.ParameterValues.MediumURL,
            FlickrClient.ParameterKeys.Format: FlickrClient.ParameterValues.ResponseFormat,
            FlickrClient.ParameterKeys.NoJSONCallback: FlickrClient.ParameterValues.DisableJSONCallback
        ] as [String : Any]
        
        let task = FlickrClient.shared().taskForGETMethod(FlickrClient.UrlComponents.Host, path: FlickrClient.UrlComponents.Path, parameters: methodParameters) { (result, error) in
            
            completionHandler(result,error?.localizedDescription)
        }
        
        return task;
    }
    
    // MARK: Helpers
    
    // Shared Instance
    class func shared() -> VTAPIManager {
        struct Singelton {
            static let sharedInstance = VTAPIManager()
        }
        return Singelton.sharedInstance
    }
}
