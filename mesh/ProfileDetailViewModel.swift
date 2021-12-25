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
        dataManager.fetchImagesWithDescriptions()?
                    .sink { (dataResponse) in
                        if dataResponse.error != nil {
                            debugPrint("ProfileDetailView Error")
                        } else {
                            let modelsArray = dataResponse.value!.models
                            for i in 0..<min(3, modelsArray.count) {
                                self.imagesWithDescription[i] = modelsArray[i]
                            }
                        }
                    }.store(in: &cancellableSet)
    }
}
