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
    
    func getImages(for latitude:Double, longitude:Double, completionHandler:@escaping (_ response:AnyObject?,_ error:NSError?)->Void) -> URLSessionDataTask {
        
        let methodParameters = [
            FlickrClient.ParameterKeys.Method: FlickrClient.ParameterValues.SearchMethod,
            FlickrClient.ParameterKeys.APIKey: FlickrClient.ParameterValues.APIKey,
            FlickrClient.ParameterKeys.Latitude: latitude,
            FlickrClient.ParameterKeys.Longitude: longitude,
            FlickrClient.ParameterKeys.SafeSearch: FlickrClient.ParameterValues.UseSafeSearch,
            FlickrClient.ParameterKeys.Extras: FlickrClient.ParameterValues.MediumURL,
            FlickrClient.ParameterKeys.Latitude: FlickrClient.ParameterValues.ResponseFormat,
            FlickrClient.ParameterKeys.NoJSONCallback: FlickrClient.ParameterValues.DisableJSONCallback
        ] as [String : Any]
        
        return FlickrClient.shared().taskForGETMethod(FlickrClient.UrlComponents.Host, method: FlickrClient.UrlMethod.SearchMethod, parameters: methodParameters, completionHandlerForGET: completionHandler)
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
