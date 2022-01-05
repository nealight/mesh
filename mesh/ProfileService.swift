//
//  ImageService.swift
//  mesh
//
//  Created by Yi Xu on 12/24/21.
//

import Foundation
import Combine
import Alamofire
import SwiftUI

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}

protocol ProfileServiceProtocol {
    func fetchMyImagesURLWithDescriptions() -> AnyPublisher<DataResponse<ProfileDetailModel, NetworkError>, Never>?
    func fetchDiscoverImagesURLWithDescriptions() -> AnyPublisher<DataResponse<ProfileDetailModel, NetworkError>, Never>?
    func uploadImageDescription(index: Int, description: String) -> AnyPublisher<DataResponse<String, NetworkError>, Never>?
    func uploadImageWithLink(putURL: String?, image: UIImage?) -> AnyPublisher<DataResponse<Data?, NetworkError>, Never>?
    func updateProfile(profileDetail: ProfileDetailModel) -> AnyPublisher<DataResponse<String, NetworkError>, Never>?
}

class ProfileService: ProfileServiceProtocol {
    static let shared: ProfileServiceProtocol = ProfileService()
    private init() { }
    
    func fetchDiscoverImagesURLWithDescriptions() -> AnyPublisher<DataResponse<ProfileDetailModel, NetworkError>, Never>? {
        fetchImagesURLWithDescriptions(URI: "api/profile/fetchDiscoverImagesURLWithDescriptions")
    }
    
    private func fetchImagesURLWithDescriptions(URI: String) -> AnyPublisher<DataResponse<ProfileDetailModel, NetworkError>, Never>? {
        guard let accessToken = AccountManager.shared.getAuthenticationToken() else {
            return nil
        }
        
        let requestURL = NetworkClient.shared.buildURL(uri: URI)
        
        let headers: HTTPHeaders = [
          "x-access-token": accessToken,
        ]
        
        return NetworkClient.shared.session.request(requestURL, method: .get, headers: headers).validate()
            .publishDecodable(type: ProfileDetailModel.self)
            .map { response in
                debugPrint(response)
                return response.mapError { error -> NetworkError in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func fetchMyImagesURLWithDescriptions() -> AnyPublisher<DataResponse<ProfileDetailModel, NetworkError>, Never>? {
        fetchImagesURLWithDescriptions(URI: "api/profile/getAllDescriptionImages")
        
    }
    
    func uploadImageDescription(index: Int, description: String) -> AnyPublisher<DataResponse<String, NetworkError>, Never>? {
        guard let accessToken = AccountManager.shared.getAuthenticationToken() else {
            return nil
        }
        
        let requestURL = NetworkClient.shared.buildURL(uri: "api/profile/addDescriptionToImage")
        
        let headers: HTTPHeaders = [
          "x-access-token": accessToken,
        ]
        
        let parameters: [String: Any] = [
            "description": description,
            "index": index
        ]
        
        return NetworkClient.shared.session.request(requestURL, method: .post, parameters: parameters, headers: headers).validate()
            .publishString()
            .map { response in
                response.mapError { error -> NetworkError in
                    return NetworkError(initialError: error, backendError: nil)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    func updateProfile(profileDetail: ProfileDetailModel) -> AnyPublisher<DataResponse<String, NetworkError>, Never>? {
        guard let accessToken = AccountManager.shared.getAuthenticationToken() else {
            return nil
        }
        
        let requestURL = NetworkClient.shared.buildURL(uri: "api/profile/updateMe")
        
        let headers: HTTPHeaders = [
          "x-access-token": accessToken,
        ]
        
        let parameters: [String: Any] = [
            "name": profileDetail.name,
            "linkedInLink": profileDetail.linkedInLink,
            "contactNumber": profileDetail.contactNumer ?? ""
        ]
        
        return NetworkClient.shared.session.request(requestURL, method: .post, parameters: parameters, headers: headers).validate()
            .publishString()
            .map { response in
                response.mapError { error -> NetworkError in
                    return NetworkError(initialError: error, backendError: nil)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    public func uploadImageWithLink(putURL: String?, image: UIImage?) -> AnyPublisher<DataResponse<Data?, NetworkError>, Never>? {
        
        guard let putURL = putURL, let image = image, let imgData = image.jpegData(compressionQuality: 1) else {
            return nil
        }
        
        return AF.upload(imgData, to: URL(string: putURL)!, method: .put, headers: nil)
            .validate()
            .publishUnserialized()
            .map { response in
            response.mapError { error -> NetworkError in
                return NetworkError(initialError: error, backendError: nil)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
}


