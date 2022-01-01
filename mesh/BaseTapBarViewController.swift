//
//  BaseTapBarViewController.swift
//  mesh
//
//  Created by Yi Xu on 12/31/21.
//

import UIKit

class BaseTapBarViewController: UITabBarController {
    
    let signInTokenTimeout = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + signInTokenTimeout)   {
            if !AccountManager.shared.isLoggedIn() {
                self.selectedIndex = 0
            }
        }
        // Do any additional setup after loading the view.
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
