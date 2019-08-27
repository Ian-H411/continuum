//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Ian Hall on 8/27/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    @IBOutlet weak var captionTextField: UITextField!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        captionTextField.text = ""
        postImage.image = nil
        buttonLabel.setTitle("select Photo", for: .focused)
        
    }


    @IBAction func addPhotoButtonTapped(_ sender: Any) {
        postImage.image = UIImage(named: "frodoPhoto")
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        if postImage.image != nil && captionTextField.text != ""{
            guard let image = postImage.image else {return}
            guard let text = captionTextField.text else {return}
            PostController.sharedInstance.createPostWith(caption:text, picture: image) { (post) in
                
            }
            self.tabBarController?.selectedIndex = 0
        }
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
}
