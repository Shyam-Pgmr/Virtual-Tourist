//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Shyam on 19/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import UIKit

class FlickrClient: NSObject {

    // MARK: Properties
    var session = URLSession.shared

    override init() {
        super.init()
    }
        
    // MARK: GET
    
    func taskForGETMethod(_ host:String, path: String, parameters: [String:Any], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Build the URL, Configure the request
        let request = NSMutableURLRequest(url: URLFromParameters(parameters, host: host, path: path))
        
        // Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // Was there an error?
            guard (error == nil) else {
                
                let nsError = (error! as NSError)
                if nsError.code == NSURLErrorNotConnectedToInternet {
                    sendError(ErrorDescription.NoInternetConnection)
                }
                else {
                    sendError("There was an error with your request: \(error!)")
                }
                return
            }
            
            // Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                let errorMessage = "Your request returned a status code \(statusCode!)"
                sendError(errorMessage)
                return
            }
            
            // Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // Shared Instance
    class func shared() -> FlickrClient {
        struct Singelton {
            static let sharedInstance = FlickrClient()
        }
        return Singelton.sharedInstance
    }
    
    // create a URL from parameters
    private func URLFromParameters(_ parameters: [String:Any], host:String, path: String) -> URL {
        
        var components = URLComponents()
        components.scheme = UrlComponents.Scheme
        components.host = host
        components.path = path
        components.queryItems = [URLQueryItem]()
        
        for (key,value) in parameters {
            let item = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(item)
        }
        
        return components.url!
    }
    
    // Given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
}
