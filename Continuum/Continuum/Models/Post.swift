//
//  Post.swift
//  Continuum
//
//  Created by Ian Hall on 8/27/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation

import UIKit.UIImage

class Post{
    
    var photoData: Data?
    
    let timeStamp: Date
    
    var caption: String
    
    var comments: [Comment]
    
    var photo: UIImage?{
        get{
        guard let photoData = photoData else{return nil}
        return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    init(caption: String,timeStamp: Date = Date(), comments: [Comment], photo: UIImage ) {
        self.timeStamp = timeStamp
        self.caption = caption
        self.comments = comments
        self.photo = photo
    }
    
}
