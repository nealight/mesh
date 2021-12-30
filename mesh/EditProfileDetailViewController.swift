//
//  EditProfileDetailViewController.swift
//  mesh
//
//  Created by Yi Xu on 12/26/21.
//

import UIKit
import SwiftUI

class EditProfileDetailViewController: UIViewController {

    
    var profileDetailVC: UIHostingController<ProfileDetailView>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profileDetailView = ProfileDetailView(viewModel: ProfileDetailViewModel(), navigationTitle: nil)
        
        profileDetailView.viewModel.editTapHandler = {
            self.performSegue(withIdentifier: "editImageSegue", sender: nil)
        }
        
        let viewCtrl = UIHostingController(rootView: profileDetailView)
        addChild(viewCtrl)
        view.addSubview(viewCtrl.view)
        // Do any additional setup after loading the view.
        
        viewCtrl.view.translatesAutoresizingMaskIntoConstraints = false
        viewCtrl.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewCtrl.view?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewCtrl.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewCtrl.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        profileDetailVC = viewCtrl
    }
    
    @IBAction func DoneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let uploadVC = segue.destination as? ProfileDetailUploadViewController else {
            return
        }
        
        uploadVC.profileDetailViewModel = profileDetailVC?.rootView.viewModel
        
    }
    
}
