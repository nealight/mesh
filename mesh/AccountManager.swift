//
//  AccountManager.swift
//  mesh
//
//  Created by Yi Xu on 12/13/21.
//

import Foundation
import Alamofire
import Combine

protocol logInDelegate {
    func logInSuccess()
    func logInFailure()
}

struct UserInfo {
    var name: String
}

class AccountManager {
    static let shared = AccountManager()
    private var loggedIn = false
    private var accessToken: UserDefaults = UserDefaults.standard
    
    private init() {
        getUserInfo(vc: nil)
    }
    
    
    func isLoggedIn() -> Bool {
        return loggedIn
    }
    
    func logOutAccount() {
        self.accessToken.set(nil, forKey: "token")
        self.loggedIn = false
    }
    
    func registerAccount(emailText: String, usernameText: String, passwordText: String) {
        
        let parameters: [String: String] = [
            "email": emailText,
            "username": usernameText,
            "password": passwordText
        ]
        
        NetworkClient.shared.session.request(NetworkClient.shared.buildURL(uri: "api/auth/signup"), method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: {response in
                debugPrint(response)
            
            })
        
    }
    
    func loginAccount(emailText: String, passwordText: String, vc: logInDelegate) {
        let parameters: [String: String] = [
            "email": emailText,
            "password": passwordText
        ]
        
        NetworkClient.shared.session.request(NetworkClient.shared.buildURL(uri: "api/auth/signin"), method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON(completionHandler: {response in
                if let json = response.value as? [String:Any], let token = json["accessToken"] as? String {
                    self.accessToken.set(token, forKey: "token")
                    self.loggedIn = true;
                    vc.logInSuccess()
                } else {
                    vc.logInFailure()
                }
            })
    }
    
    func getAuthenticationToken() -> String? {
        return accessToken.object(forKey: "token") as? String
    }
    
    func challengeTokenValidity() -> URLSession.DataTaskPublisher? {
        guard let accessToken = getAuthenticationToken() else {
            return nil
        }
        
        let headers: HTTPHeaders = [
          "x-access-token": accessToken,
        ]
        
        do {
            return URLSession.shared.dataTaskPublisher(for: try URLRequest(url: NetworkClient.shared.buildURL(uri: "api/auth/challenge"), method: .get, headers: headers))
        } catch {
            return nil
        }
    }
    
    func getUserInfo(vc: AccessingUserInfo?) {
        guard let accessToken = getAuthenticationToken() else {
            return
        }
        
        let headers: HTTPHeaders = [
          "x-access-token": accessToken,
        ]
        
        NetworkClient.shared.session.request(NetworkClient.shared.buildURL(uri: "api/auth/me"), method: .get, headers: headers).validate().responseJSON(completionHandler: {response in
            if let json = response.value as? [String:Any] {
                guard let username = json["username"] as? String else {
                    self.loggedIn = false
                    return
                }
                if let vc = vc {
                    vc.gotUserInfo(userInfo: UserInfo(name: username))
                }
                self.loggedIn = true
                return

            }
            self.loggedIn = false
        })
        
    }
    
}
