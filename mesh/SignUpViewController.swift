//
//  SignUpViewController.swift
//  mesh
//
//  Created by Yi Xu on 12/4/21.
//

import UIKit



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

        AccountManager.shared.registerAccount(emailText: emailText, usernameText: usernameText, passwordText: passwordText)
        
        
        dismiss(animated: true, completion: nil)
    }
}
