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
    
    var settingsVC: UIHostingController<SettingsView>?
    
    func retreivedImage(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        self.profileImage.image = image
    }
    

    let imagePicker = UIImagePickerController()
    let signInTokenTimeout = 0.5
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameTF: UILabel!
    let accountManager = AccountManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareView()

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
        
        
        let settingsView = SettingsView(viewModel: SettingsViewModel())
        settingsVC = UIHostingController(rootView: settingsView)
    }
    
    func gotUserInfo(userInfo: UserInfo) {
        self.nameTF.text = userInfo.name
        self.nameTF.alpha = 1
        ImageManager.shared.retrieveImage(vc: self)
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
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        accountManager.logOutAccount()
        self.performSegue(withIdentifier: "LogInSegue", sender: nil)
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        if let settingsVC = settingsVC {
            settingsVC.modalPresentationStyle = .fullScreen
            present(settingsVC, animated: true, completion: nil)
            
        }
    }
    
    
    private func prepareView() {
        accountManager.getUserInfo(vc: self)
        
    }
    

}
