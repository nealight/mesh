//
//  ProfileDetailModel.swift
//  mesh
//
//  Created by Yi Xu on 12/23/21.
//

import Foundation
import SwiftUI

class ProfileDetailModel: Codable {
    var models: [ProfileImageDescriptionModel]?
    
    var name: String
    var linkedInLink: String
    var contactNumer: String?
    
    init() {
        name = ""
        linkedInLink = ""
    }
    
}


class ProfileImageDescriptionModel: Codable {
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
