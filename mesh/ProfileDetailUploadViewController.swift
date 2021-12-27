//
//  ProfileDetailUploadViewController.swift
//  mesh
//
//  Created by Yi Xu on 12/26/21.
//

import UIKit

class ProfileDetailUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var profileImage: UIImageView!
    var profileDetailViewModel: ProfileDetailViewModel?
    
    @IBOutlet var descriptionTF: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.profileImage.isUserInteractionEnabled = true
        self.imagePicker.delegate = self
        
        guard let image = self.profileImage else {
            return
        }
        
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.blue.cgColor
        image.layer.cornerRadius = image.frame.height/20
        image.clipsToBounds = true
    }
    
    
    
    @IBAction func tappedOnImage(_ sender: UITapGestureRecognizer) {
        debugPrint("profile image tap recognized")
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func tappedOnUploadButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
        
        if let image = self.profileImage.image {
            ImageManager.shared.uploadImageWithLink(putURL: profileDetailViewModel?.getSelectedPicturePUTURL(), image: image)
        }
    }
    
    
    
}
