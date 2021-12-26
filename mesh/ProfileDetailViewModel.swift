//
//  ProfileDetailViewModel.swift
//  mesh
//
//  Created by Yi Xu on 12/23/21.
//

import Foundation
import SwiftUI
import Combine

final class ProfileDetailViewModel: ObservableObject {
    @Published var imagesWithDescription = [ProfileDetailModel]()
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ServiceProtocol
    
    init(dataManager: ServiceProtocol = ImageService.shared) {
        self.dataManager = dataManager
        
        self.imagesWithDescription.append(ProfileDetailModel())
        self.imagesWithDescription.append(ProfileDetailModel())
        self.imagesWithDescription.append(ProfileDetailModel())
        
        retreivedImages()
    }
    
    
    
    
    func retreivedImages() {
        dataManager.fetchImagesURLWithDescriptions()?
                    .sink { (dataResponse) in
                        if dataResponse.error != nil {
                            debugPrint("ProfileDetailView Error")
                        } else {
                            let modelsArray = dataResponse.value!.models
                            for i in 0..<min(3, modelsArray.count) {
                                self.imagesWithDescription[i] = modelsArray[i]
                                self.load(url: modelsArray[i].getURL, toIndex: i)
                            }
                        }
                    }.store(in: &cancellableSet)
    }
    
    @Published var images: [UIImage?] = [nil, nil, nil]

    
    func load(url: String, toIndex: Int) {
        guard let convertedURL = URL(string: url) else {
            return
        }
        
        cancellableSet.insert(URLSession.shared.dataTaskPublisher(for: convertedURL)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.images[toIndex] = $0 })
    }

}



