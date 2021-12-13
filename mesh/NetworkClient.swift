//
//  NetworkClient.swift
//  mesh
//
//  Created by Yi Xu on 12/10/21.
//

import Foundation
import Alamofire

class NetworkClient {
  let evaluators = [
    "localhost":
    
    PinnedCertificatesTrustEvaluator(certificates: [
      Certificates.meshHost
    ], acceptSelfSignedCertificates: true)
    
  ]
  
  let session: Session
  
  
  private init() {
    

    session = Session(
        serverTrustManager: ServerTrustManager(evaluators: evaluators)
    )
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
