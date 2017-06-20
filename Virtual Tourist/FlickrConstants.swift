//
//  FlickrConstants.swift
//  Virtual Tourist
//
//  Created by Shyam on 19/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    // MARK: URLComponents
    struct UrlComponents {
        static let Scheme = "https"
        static let Host = "api.flickr.com"
        static let Path = "/services/rest"
    }
    
    // MARK: URL Methods
    struct UrlMethod {
        static let SearchMethod = "flickr.photos.search"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let Latitude = "lat"
        static let Longitude = "lon"
        static let Page = "page"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "8294bb1522e71b4e3d755bca37733a97"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
    }
    
    // MARK: Response Keys
    struct ResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    
    // MARK: Response Keys
    struct ResponseValues {
        static let OKStatus = "ok"
    }
    
    
    // MARK: Error Description
    struct ErrorDescription {
        static let NoInternetConnection = "Check your Internet Connection"
    }
}
