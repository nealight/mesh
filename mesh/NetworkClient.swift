//
//  NetworkClient.swift
//  mesh
//
//  Created by Yi Xu on 12/10/21.
//

import Foundation
import Alamofire

class NetworkClient {
    let localhostTestingDomain = "https://localhost/"
    let remoteDomain = "https://mesh.dashu.coffee/"
    
    private var localTestingEnabled = false;
    
    private func buildURLForLocalTesting(uri: String) -> String {
        return NetworkClient.shared.localhostTestingDomain + uri;
    }
    
    public func buildURL(uri: String) -> String {
        if localTestingEnabled {
            return buildURLForLocalTesting(uri: uri)
        }
        
        return NetworkClient.shared.remoteDomain + uri;
    }
    
    let evaluators = [
    "localhost":

    PinnedCertificatesTrustEvaluator(certificates: [
      Certificates.meshHost
    ], acceptSelfSignedCertificates: true)
    ]
    

    let session: Session


    private init() {

        if localTestingEnabled {
        session = Session(
            serverTrustManager: ServerTrustManager(evaluators: evaluators)
        )
        } else {
            session = Session()
        }
    }


    public static let shared = NetworkClient()
  
}

struct Certificates {
  static let meshHost =
    Certificates.certificate(filename: "certificate")
  
  private static func certificate(filename: String) -> SecCertificate {
    let filePath = Bundle.main.path(forResource: filename, ofType: "der")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
    let certificate = SecCertificateCreateWithData(nil, data as CFData)!
    
    return certificate
  }
}
