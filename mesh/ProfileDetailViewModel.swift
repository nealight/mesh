//
//  ProfileDetailViewModel.swift
//  mesh
//
//  Created by Yi Xu on 12/23/21.
//

import Foundation

final class ProfileDetailViewModel: ObservableObject {
    @Published var selectedPicture: ProfilePictureNumber = .First
}
