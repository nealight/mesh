//
//  SignUpViewController.swift
//  mesh
//
//  Created by Yi Xu on 12/4/21.
//

import UIKit
import Alamofire


class SignUpViewController: UIViewController {
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigationå
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet var passwordInput: UITextField!
    @IBOutlet var emailInput: UITextField!
    @IBOutlet var usernameInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerButtonTouched(_ sender: Any) {
        guard let passwordText = passwordInput.text, let emailText = emailInput.text, let usernameText = usernameInput.text else {
            return
        }
        
        
        
            
            
        let parameters: [String: String] = [
            "email": emailText,
            "username": usernameText,
            "password": passwordText,
        ]
        
        
        

        // All three of these calls are equivalent
        NetworkClient.shared.session.request("https://localhost:8443/api/auth/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: {response in
            debugPrint(response)
            })
        
        
        dismiss(animated: true, completion: nil)
    }
}
