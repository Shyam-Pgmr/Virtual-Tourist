//
//  VTConstants.swift
//  Virtual Tourist
//
//  Created by Shyam on 20/06/17.
//  Copyright © 2017 Shyam. All rights reserved.
//

import Foundation

struct Constant {
    
    struct Storyboard {
        
        struct ViewController {
            static let PhotoAlbum = "VTPhotoAlbumViewController"
        }
    }
    
    // MARK: Alert
    struct Alert {
        
        struct Title {
            static let Validation = "Validation"
            static let ServerError = "Server Error"
            static let Oops = "Oops"
            static let Success = "Success"
            
        }
        
        struct Message {
            static let InvalidURL = "Invalid URL"
        }
        
        struct ActionTitle {
            static let OK = "OK"
        }
        
    }
    
    // MARK: Segue
    struct Segue {
        static let PresentHome = "PresentHome"
    }
}
