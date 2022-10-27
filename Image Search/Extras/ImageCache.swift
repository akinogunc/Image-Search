//
//  ImageCache.swift
//  Image Search
//
//  Created by Akin Ogunc on 27.10.2022.
//

import Foundation
import UIKit

class ImageCache: NSObject {
    
    class func path(name: String) -> String {
        let finalPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        return finalPath + name
    }
    
    class func getImage(url: String, completion: @escaping(UIImage) -> Void) {
        guard let localImage = UIImage(contentsOfFile: self.path(name: url)) else {
            DispatchQueue.global(qos: .background).async {
                let imageData = NSData(contentsOf: URL(string: url)!)
                DispatchQueue.main.async( execute: {
                    imageData?.write(toFile: self.path(name: url), atomically: true)
                    if imageData != nil{
                        let finalImage = UIImage(data: imageData! as Data)
                        completion(finalImage!)
                    }
                })
            }
            return
        }
        completion(localImage)
    }
}
