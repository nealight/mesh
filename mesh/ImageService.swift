//
//  ImageService.swift
//  mesh
//
//  Created by Yi Xu on 12/24/21.
//

import Foundation
import Combine
import Alamofire

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}

protocol ServiceProtocol {
    func fetchImagesURLWithDescriptions() -> AnyPublisher<DataResponse<ProfileDetailsModel, NetworkError>, Never>?
}

class ImageService: ServiceProtocol {
    
    static let shared: ServiceProtocol = ImageService()
    private init() { }
    
    func fetchImagesURLWithDescriptions() -> AnyPublisher<DataResponse<ProfileDetailsModel, NetworkError>, Never>? {
        guard let accessToken = AccountManager.shared.getAuthenticationToken() else {
            return nil
        }
        
        let requestURL = NetworkClient.shared.buildURL(uri: "api/profile/getAllDescriptionImages")
        
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
    
}


