//
//  Utility.swift
//  AssignmentGitSearch
//
//  Created by Rahul Mukherjee on 12/07/19.
//  Copyright © 2019 Rahul Mukherjee. All rights reserved.
//

import Foundation
import UIKit

//ImageCache to cache image after downloading so that next time during same session not need to download the image again
let IMAGECACHE = NSCache<NSString, AnyObject>()

/// Universal Print/log method
func AppLog(_ text: String) {
    print(text)
}

///Get Cache  image from IMAGECACHE against url, if not present then nil return
func isCacheImage(url: URL) -> UIImage? {
    if let cacheImage = IMAGECACHE.object(forKey: url.absoluteString as NSString) as? UIImage {
        return cacheImage
    }
    return nil
}

///Store the image against url to IMAGECACHE
func cacheImage(image: UIImage, url: URL) {
    IMAGECACHE.setObject(image, forKey: url.absoluteString as NSString)
}
