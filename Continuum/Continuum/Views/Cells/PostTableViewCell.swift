//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Ian Hall on 8/27/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
   
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    var post: Post?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        guard let post = post else {return}
        postImage.image = post.photo
        captionLabel.text = post.caption
        commentLabel.text = "\(post.comments.count)"
    }
    
}
