//
//  ImageLoader.swift
//  mesh
//
//  Created by Yi Xu on 12/25/21.
//

import Foundation

import SwiftUI
import Combine
import Foundation
import Alamofire

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private var cancellable: AnyCancellable?
    private let url: String

    init(url: String) {
        self.url = url
    }

    deinit {
        cancel()
    }
    
    func load() {
        guard let convertedURL = URL(string: url) else {
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: convertedURL)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }

    func cancel() {
        cancellable?.cancel()
    }
}


