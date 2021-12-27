//
//  ProfileViewController.swift
//  mesh
//
//  Created by Yi Xu on 12/13/21.
//

import UIKit
import SwiftUI

protocol AccessingUserInfo {
    func gotUserInfo(userInfo: UserInfo)
}

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, AccessingUserInfo, UINavigationControllerDelegate, ImageDataDelegate {
    func retreivedImage(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        self.profileImage.image = image
    }
    

    let imagePicker = UIImagePickerController()
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameTF: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !AccountManager.shared.isLoggedIn() {
            performSegue(withIdentifier: "LogInSegue", sender: nil)
        }
        AccountManager.shared.getUserInfo(vc: self)
        ImageManager.shared.retrieveImage(vc: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTF.alpha = 0
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        self.profileImage.isUserInteractionEnabled = true
        
        guard let image = self.profileImage else {
            return
        }
        
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.blue.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    func gotUserInfo(userInfo: UserInfo) {
        self.nameTF.text = userInfo.name
        self.nameTF.alpha = 1
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func profileImageTapped(_ sender: UITapGestureRecognizer) {
        print("profile image tap recognized")
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
        
        if let image = self.profileImage.image {
            ImageManager.shared.uploadImage(image: image)
        }
        
    }
    
    
    
    

}
