//
//  ProfileViewController.swift
//  mesh
//
//  Created by Yi Xu on 12/13/21.
//

import UIKit

protocol AccessingUserInfo {
    func gotUserInfo(userInfo: UserInfo)
}

class ProfileViewController: UIViewController, AccessingUserInfo {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameTF: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !AccountManager.sharedInstance.isLoggedIn() {
            performSegue(withIdentifier: "LogInSegue", sender: nil)
        }
        AccountManager.sharedInstance.getUserInfo(vc: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func gotUserInfo(userInfo: UserInfo) {
        self.nameTF.text = userInfo.name
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
