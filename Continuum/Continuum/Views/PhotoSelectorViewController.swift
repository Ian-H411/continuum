//
//  PhotoSelectorViewController.swift
//  Continuum
//
//  Created by Ian Hall on 8/28/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit

protocol PhotoSelectorViewControllerDelegate:AnyObject {
    func photoSelectorViewControllerSelected(image: UIImage)
}

class PhotoSelectorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var photoImage: UIImageView!
    
    
    weak var delegate: PhotoSelectorViewControllerDelegate?
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func addAPhotoButtonTapped(_ sender: Any) {
        imageAlert()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {dismiss(animated: true, completion: nil); return}
        delegate?.photoSelectorViewControllerSelected(image: chosenImage)
        photoImage.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageAlert(){
        imagePicker.delegate = self
        let alert = UIAlertController(title: "pick a photo or shoot a shot", message: "DEW IT", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "camera", style: .default) { (_) in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            alert.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photosAction = UIAlertAction(title: "photo library", style: .default) { (_) in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            alert.addAction(photosAction)
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation
    
    
    
    
}
