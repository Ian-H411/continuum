//
//  Comment.swift
//  Continuum
//
//  Created by Ian Hall on 8/27/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation

class Comment{
    
    var text: String
    
    var timeStamp: Date
    
    weak var post: Post?
    
    init(text:String, timeStamp: Date = Date(), post:Post){
        self.text = text
        self.timeStamp = timeStamp
        self.timeStamp = timeStamp
    }
}
