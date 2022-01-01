//
//  BaseTapBarViewController.swift
//  mesh
//
//  Created by Yi Xu on 12/31/21.
//

import UIKit
import Combine

class BaseTapBarViewController: UITabBarController {
    
    let signInTokenTimeout = 0.5
    private var cancellableSet: Set<AnyCancellable> = []
    let accountManager = AccountManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        accountManager.$loggedInStatus
            .sink { [self] received in
                if received == .loggedOut {
                    self.selectedIndex = 0
            }
        }.store(in: &cancellableSet)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
