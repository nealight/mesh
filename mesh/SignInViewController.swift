//
//  SignInViewController.swift
//  mesh
//
//  Created by Yi Xu on 12/13/21.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate, logInDelegate {
    func logInSuccess() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func logInFailure() {
        let alert = UIAlertController(title: "Login Failure", message: "Your account and password do not match.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        
        

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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        guard let passwordText = passwordTF.text, let emailText = emailTF.text else {
            return
        }
        
        AccountManager.shared.loginAccount(emailText: emailText, passwordText: passwordText, vc: self)
    }
    

}
