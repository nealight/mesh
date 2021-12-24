//
//  ProfileDetailView.swift
//  mesh
//
//  Created by Yi Xu on 12/23/21.
//

import SwiftUI

enum ProfilePictureNumber: String, CaseIterable {
    case First = "First"
    case Second = "Second"
    case Third = "Third"
}

struct ProfileDetailView: View {
    @StateObject private var viewModel = ProfileDetailViewModel()
    
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Choose Profile Picture", selection: $viewModel.selectedPicture) {
                    ForEach(ProfilePictureNumber.allCases, id:\.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()
                ImageWithDescriptionView(profileDescription: "Selfie")
            }.navigationTitle("Profile Pictures")
        }
    }
}

struct ImageWithDescriptionView: View {
    var profileDescription: String
    
    var body: some View {
        VStack {
            Image(profileDescription).resizable()
                .scaledToFit()
                .frame(width: 250.0, height: 250.0, alignment: .top).shadow(color: .white, radius: 100)
            Text("Profile Description")
        }
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView()
    }
}
