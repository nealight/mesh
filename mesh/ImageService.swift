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

protocol ServiceProtocol {
    func fetchMyImagesURLWithDescriptions() -> AnyPublisher<DataResponse<ProfileDetailsModel, NetworkError>, Never>?
    func fetchDiscoverImagesURLWithDescriptions() -> AnyPublisher<DataResponse<ProfileDetailsModel, NetworkError>, Never>?
    func uploadImageDescription(index: Int, description: String) -> AnyPublisher<DataResponse<String, NetworkError>, Never>?
    func uploadImageWithLink(putURL: String?, image: UIImage?) -> AnyPublisher<DataResponse<Data?, NetworkError>, Never>?
}

class ImageService: ServiceProtocol {
    func fetchDiscoverImagesURLWithDescriptions() -> AnyPublisher<DataResponse<ProfileDetailsModel, NetworkError>, Never>? {
        fetchImagesURLWithDescriptions(URI: "api/profile/getDiscoverDescriptionImages")
    }
    
    
    static let shared: ServiceProtocol = ImageService()
    private init() { }
    
    private func fetchImagesURLWithDescriptions(URI: String) -> AnyPublisher<DataResponse<ProfileDetailsModel, NetworkError>, Never>? {
        guard let accessToken = AccountManager.shared.getAuthenticationToken() else {
            return nil
        }
        
        let requestURL = NetworkClient.shared.buildURL(uri: URI)
        
        let headers: HTTPHeaders = [
          "x-access-token": accessToken,
        ]
        
        return NetworkClient.shared.session.request(requestURL, method: .get, headers: headers).validate()
            .publishDecodable(type: ProfileDetailsModel.self)
            .map { response in
                response.mapError { error -> NetworkError in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func fetchMyImagesURLWithDescriptions() -> AnyPublisher<DataResponse<ProfileDetailsModel, NetworkError>, Never>? {
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


