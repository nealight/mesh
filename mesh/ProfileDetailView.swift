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

struct ProfileDetailView: View {
    @StateObject private var viewModel = ProfileDetailViewModel()
    @State var selectedPicture: ProfilePictureNumber = .First
    
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Choose Profile Picture", selection: $selectedPicture) {
                    ForEach(ProfilePictureNumber.allCases, id:\.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()
                ImageWithDescriptionView(profileDescription: viewModel.imagesWithDescription[mapPictureNumberToIndex(number: self.selectedPicture)].description)
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
            Text(profileDescription)
        }
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView()
    }
}
