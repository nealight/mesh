//
//  ProfileDetailModel.swift
//  mesh
//
//  Created by Yi Xu on 12/23/21.
//

import Foundation
import SwiftUI

class ProfileDetailsModel: Codable {
    var models: [ProfileDetailModel]
    var name: String
}


class ProfileDetailModel: Codable {
    var getURL: String
    var putURL: String?
    var description: String
    
    init() {
        getURL = ""
        description = ""
    }
}

class ProfileDetailImagesModel {
    var firstImage = Image("")
    var secondImage = Image("")
    var thirdImage = Image("")
}
