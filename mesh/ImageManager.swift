//
//  ImagePost.swift
//  mesh
//
//  Created by Yi Xu on 12/18/21.
//

import Foundation

import Alamofire
import SwiftyJSON

protocol ImageDataDelegate {
    func retreivedImage(image: UIImage?)
}

class ImageManager {
    private var image: UIImage?
    private var imageDataDelegate: ImageDataDelegate?
    public static let shared = ImageManager()
    private init() {
        
    }
    
    private func getTemporaryLinks(method: String, imageAccessCompletionHandler: @escaping (String?) -> Void) {
        guard let accessToken = AccountManager.shared.getAuthenticationToken() else {
            return
        }
        
        let requestURL = NetworkClient.shared.buildURL(uri: "api/profile/profileimagelink")
        
        let headers: HTTPHeaders = [
          "x-access-token": accessToken,
        ]
        
        NetworkClient.shared.session.request(requestURL, method: .get, headers: headers).validate().responseJSON(completionHandler: {response in
            debugPrint(response)
            if let json = response.value as? [String:Any] {
                imageAccessCompletionHandler(json[method] as? String)
            }
        })
    }
    
    private func uploadImageWithLink(putURL: String?) {
        
        guard let putURL = putURL else {
            return
        }
        
        guard let image = self.image else {
            return
        }

        guard let imgData = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        AF.upload(imgData, to: URL(string: putURL)!, method: .put, headers: nil)
////        AF.upload(multipartFormData: { (multipartFormData) in
//                multipartFormData.append(imgData, withName: "file", fileName: "swift_file.png", mimeType: "image/png")
//    }, to: putURL)
    }
    
    
    public func uploadImage(image: UIImage) {
        self.image = image
        getTemporaryLinks(method: "putURL", imageAccessCompletionHandler: uploadImageWithLink)
        
    }
    
    public func retrieveImage(vc: ImageDataDelegate) {
        self.imageDataDelegate = vc
        getTemporaryLinks(method: "getURL", imageAccessCompletionHandler: retrieveImageWithLink)
    }
    
    private func retrieveImageWithLink(getURL: String?) {
        guard let getURL = getURL else {
            return
        }
        
        NetworkClient.shared.session.request(getURL, method: .get).validate().responseData(completionHandler: {response in
            debugPrint(response)
            
            var imgData : Data                    //create variable of type data
            imgData = Data(response.data!)       // access the data through response.data
            self.imageDataDelegate?.retreivedImage(image: UIImage(data: imgData))
        })
    }
}
