//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Ian Hall on 8/27/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var captionTextField: UITextField!
    
    var landingPad: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        captionTextField.text = ""
     
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        if landingPad != nil && captionTextField.text != ""{
            guard let image = landingPad else {return}
            guard let text = captionTextField.text else {return}
            PostController.sharedInstance.createPostWith(caption:text, picture: image) { (post) in
                
            }
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photopick"{
            if let destinationvc = segue.destination as? PhotoSelectorViewController{
                destinationvc.delegate = self
            }
        }
        
    }
}
extension AddPostTableViewController: PhotoSelectorViewControllerDelegate{
    func photoSelectorViewControllerSelected(image: UIImage) {
        landingPad = image
    }
}
