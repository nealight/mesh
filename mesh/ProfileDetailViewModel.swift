//
//  ProfileDetailViewModel.swift
//  mesh
//
//  Created by Yi Xu on 12/23/21.
//

import Foundation
import SwiftUI
import Combine

enum ProfilePictureNumber: String, CaseIterable {
    case First = "First"
    case Second = "Second"
    case Third = "Third"
}

func mapPictureNumberToIndex(number: ProfilePictureNumber) -> Int {
    switch number {
    case .First:
        return 0
    case .Second:
        return 1
    case .Third:
        return 2
    }
}

final class ProfileDetailViewModel: ObservableObject {
    @Published var imagesWithDescription = [ProfileDetailModel]()
    @Published var profilePictureNumber: ProfilePictureNumber = .First
    @Published var name: String = "Annonymous"
    
    func getSelectedPicturePUTURL() -> String? {
        return imagesWithDescription[getSelectedPictureIndex()].putURL
    }
     
     func getSelectedPictureIndex() -> Int {
         return mapPictureNumberToIndex(number: self.profilePictureNumber)
     }
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ServiceProtocol
    var editTapHandler: (() -> Void)?
    
    init(dataManager: ServiceProtocol = ImageService.shared) {
        self.dataManager = dataManager
        
        self.imagesWithDescription.append(ProfileDetailModel())
        self.imagesWithDescription.append(ProfileDetailModel())
        self.imagesWithDescription.append(ProfileDetailModel())
        
        retreivedImages()
    }
    
    func handleTapOnImage() {
        if let editTapHandler = editTapHandler {
            editTapHandler()
        }
        
    }
    
    
    func retreivedImages() {
        dataManager.fetchMyImagesURLWithDescriptions()?
                    .sink { (dataResponse) in
                        if dataResponse.error != nil {
                            debugPrint("ProfileDetailView Error")
                        } else {
                            let modelsArray = dataResponse.value!.models
                            self.name = dataResponse.value!.name
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



