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
                ImageWithDescriptionView(profileDescription: viewModel.imagesWithDescription[mapPictureNumberToIndex(number: self.selectedPicture)].description, vm: viewModel, selectedPicture: mapPictureNumberToIndex(number: self.selectedPicture)).onTapGesture {
                    
                }
                
                Spacer()
            }.navigationTitle("Profile Pictures")
        }
    }
}

struct ImageWithDescriptionView: View {
    var profileDescription: String
    var vm: ProfileDetailViewModel
    var selectedPicture: Int
    
    var body: some View {
        VStack {
            AsyncImage(
                        placeholder: {Text("No picture yet!")},
                        vm: vm,
                        selectedPicture: selectedPicture
                    )
                .aspectRatio(contentMode: .fill)
                .frame(width: 250.0, height: 250.0, alignment: .center).shadow(color: .white, radius: 100)
            Spacer()
            Text(profileDescription)
            Spacer()
        }
    }
}

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ProfileDetailViewModel
    private let placeholder: Placeholder
    private let selectedPicture: Int

    init(@ViewBuilder placeholder: () -> Placeholder, vm: ProfileDetailViewModel, selectedPicture: Int) {
        self.placeholder = placeholder()
        self.selectedPicture = selectedPicture
        _loader = StateObject(wrappedValue: vm)
    }

    var body: some View {
        content
    }

    private var content: some View {
        Group {
            if loader.images[self.selectedPicture] != nil {
                Image(uiImage: loader.images[self.selectedPicture]!).resizable()
            } else {
                placeholder
            }
        }
    }
}



struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView()
    }
}
