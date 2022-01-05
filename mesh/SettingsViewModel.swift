//
//  SettingsViewModel.swift
//  mesh
//
//  Created by Yi Xu on 12/31/21.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var profileInfo: ProfileDetailModel = ProfileDetailModel()
    var dataManager: ProfileServiceProtocol
    
    init(dataManager: ProfileServiceProtocol = ProfileService.shared) {
        self.dataManager = dataManager
    }
    
    func loadProfileInfo() {
        dataManager.fetchProfileInfo(profileType: .Me)?
                    .sink { (dataResponse) in
                        if dataResponse.error != nil {
                            debugPrint("SettingsViewModel Error")
                        } else {
                            self.profileInfo = dataResponse.value!
                        }
                    }.store(in: &cancellableSet)
    }
    
    func updateProfileInfo() {
        dataManager.updateProfile(profileDetail: profileInfo)?.sink { _ in
            self.loadProfileInfo()
            return
        }.store(in: &cancellableSet)
        
    }
}
