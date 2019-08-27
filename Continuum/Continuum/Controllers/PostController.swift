//
//  PostController.swift
//  Continuum
//
//  Created by Ian Hall on 8/27/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
import UIKit.UIImage

class PostController{
    
    static let sharedInstance = PostController()
    
    var posts = [Post]()
    
    //crud
    
    //MARK: - CREATE
    
    func addComment(with post: Post, text: String, completion: @escaping (Comment) -> Void ){
        let newComment = Comment(text: text, post: post)
        post.comments.append(newComment)
    }
    
    func createPostWith(caption: String, picture: UIImage, completion: @escaping (Post?) ->Void){
      let newPost =  Post(caption: caption, comments: [], photo: picture)
        posts.append(newPost)
    }
}
