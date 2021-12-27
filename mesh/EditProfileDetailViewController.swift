//
//  EditProfileDetailViewController.swift
//  mesh
//
//  Created by Yi Xu on 12/26/21.
//

import UIKit
import SwiftUI

class EditProfileDetailViewController: UIViewController {

    let viewCtrl = UIHostingController(rootView: ProfileDetailView(navigationTitle: "My Public Profile"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(viewCtrl)
        view.addSubview(viewCtrl.view)
        // Do any additional setup after loading the view.
        
        viewCtrl.view.translatesAutoresizingMaskIntoConstraints = false
        viewCtrl.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewCtrl.view?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewCtrl.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewCtrl.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func DoneButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
}
