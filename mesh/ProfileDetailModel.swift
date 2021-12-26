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
}


class ProfileDetailModel: Codable {
    var getURL: String
    var putURL: String
    var description: String
    
    init() {
        getURL = ""
        putURL = ""
        description = ""
    }
}

class ProfileDetailImagesModel {
    var firstImage = Image("")
    var secondImage = Image("")
    var thirdImage = Image("")
}
