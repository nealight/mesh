//
//  ProfileDetailUploadViewController.swift
//  mesh
//
//  Created by Yi Xu on 12/26/21.
//

import UIKit
import Combine

class ProfileDetailUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var profileImage: UIImageView!
    var profileDetailViewModel: ProfileDetailViewModel?
    let imageManager = ImageManager.shared
    let imageService = ImageService.shared
    
    @IBOutlet var descriptionTF: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.profileImage.isUserInteractionEnabled = true
        self.imagePicker.delegate = self
        self.descriptionTF.delegate = self
        
        guard let image = self.profileImage else {
            return
        }
        
        self.profileImage.image = profileDetailViewModel?.images[profileDetailViewModel?.getSelectedPictureIndex() ?? 0]
        
        self.descriptionTF.text = profileDetailViewModel?.imagesWithDescription[profileDetailViewModel?.getSelectedPictureIndex() ?? 0].description
        
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
        imageService.uploadImageDescription(index: profileDetailViewModel?.getSelectedPictureIndex() ?? 0, description: descriptionTF.text ?? "")?.sink { (response) in
            if (response.error != nil) {
                debugPrint("Description upload error")
            } else {
                self.profileDetailViewModel?.retreivedImages()
                self.dismiss(animated: true, completion: nil)
            }
        }.store(in: &cancellableSet)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
        
        if let image = self.profileImage.image {
            imageService.uploadImageWithLink(putURL: profileDetailViewModel?.getSelectedPicturePUTURL(), image: image)?.sink { (response) in
                if (response.error != nil) {
                    debugPrint("Profile Detail Image upload error")
                } else {
                    self.profileDetailViewModel?.retreivedImages()
                }
            }
            .store(in: &cancellableSet)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
}
