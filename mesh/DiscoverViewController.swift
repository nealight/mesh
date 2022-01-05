//
//  DiscoverViewController.swift
//  mesh
//
//  Created by Yi Xu on 12/29/21.
//

import UIKit
import SwiftUI
import Combine
import SafariServices

struct DiscoverError: Error {
    
}

class DiscoverViewController: UIViewController {
    var profileDetailVC: UIHostingController<ProfileDetailView>?
    var profileDetailView: ProfileDetailView?
    private var cancellableSet: Set<AnyCancellable> = []
    let accountManager = AccountManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        accountManager.$loggedInStatus
            .sink { [weak self] received in
                if received == .loggedIn {
                self?.initializeProfileView()
            
            }
        }.store(in: &cancellableSet)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AccountManager.shared.challengeTokenValidity()
    }
    
    
    func initializeProfileView() {
        profileDetailView = ProfileDetailView(viewModel: ProfileDetailViewModel(profileType: .Public), navigationTitle: nil)

        guard let profileDetailView = profileDetailView else {
            return
        }
        
        let viewCtrl = UIHostingController(rootView: profileDetailView)
        addChild(viewCtrl)
        view.addSubview(viewCtrl.view)
        
        viewCtrl.view.translatesAutoresizingMaskIntoConstraints = false
        viewCtrl.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewCtrl.view?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewCtrl.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewCtrl.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        profileDetailVC = viewCtrl
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func pressedOnLike(_ sender: UIBarButtonItem) {
        initializeProfileView()
    }
    
    @IBAction func pressedOnDislike(_ sender: UIBarButtonItem) {
        initializeProfileView()
    }
    
    @IBAction func tappedOnWeb(_ sender: UIBarButtonItem) {
        guard let url = URL(string: (profileDetailView?.viewModel.websiteLink) ?? "") else {
            return
        }
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }
    
}
