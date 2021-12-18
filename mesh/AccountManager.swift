//
//  AccountManager.swift
//  mesh
//
//  Created by Yi Xu on 12/13/21.
//

import Foundation
import Alamofire

struct UserInfo {
    var name: String
}

class AccountManager {
    static let shared = AccountManager()
    private var loggedIn = false
    private var accessToken: String?
    
    private init() {
        
    }
    
    
    func isLoggedIn() -> Bool {
        return loggedIn
    }
    
    func registerAccount(emailText: String, usernameText: String, passwordText: String) {
        
        let parameters: [String: String] = [
            "email": emailText,
            "username": usernameText,
            "password": passwordText
        ]
        
        NetworkClient.shared.session.request(NetworkClient.shared.buildURL(uri: "api/auth/signup"), method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: {response in
                debugPrint(response)
                if let json = response.value as? [String:Any] {
                    debugPrint(json["message"])
                }
            
            })
        
    }
    
    func loginAccount(emailText: String, passwordText: String, vc: SignInViewController) {
        let parameters: [String: String] = [
            "email": emailText,
            "password": passwordText
        ]
        
        NetworkClient.shared.session.request(NetworkClient.shared.buildURL(uri: "api/auth/signin"), method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: {response in
                debugPrint(response)
                if let json = response.value as? [String:Any] {
                    debugPrint(json["accessToken"])
                    self.accessToken = json["accessToken"] as? String
                    self.loggedIn = true;
                    vc.dismiss(animated: true, completion: nil)
                    
                }
            
            })
    }
    
    func getAuthenticationToken() -> String? {
        return accessToken
    }
    
    func getUserInfo(vc: AccessingUserInfo) {
        guard let accessToken = accessToken else {
            return
        }
        
        let headers: HTTPHeaders = [
          "x-access-token": accessToken,
        ]
        
        NetworkClient.shared.session.request(NetworkClient.shared.buildURL(uri: "api/auth/me"), method: .get, headers: headers).validate().responseJSON(completionHandler: {response in
                debugPrint(response)
                if let json = response.value as? [String:Any] {
                    vc.gotUserInfo(userInfo: UserInfo(name: json["username"] as! String))
                }
            
        })
        
    }
}
