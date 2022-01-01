//
//  ProfileDetailView.swift
//  mesh
//
//  Created by Yi Xu on 12/23/21.
//

import SwiftUI



struct ProfileDetailView: View {
    @ObservedObject public var viewModel: ProfileDetailViewModel
    let navigationTitle: String?
    
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Choose Profile Picture", selection: $viewModel.profilePictureNumber) {
                    ForEach(ProfilePictureNumber.allCases, id:\.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()
                Spacer()
                Spacer()
                ImageWithDescriptionView(profileDescription: viewModel.imagesWithDescription[viewModel.getSelectedPictureIndex()].description, vm: viewModel, selectedPicture: viewModel.getSelectedPictureIndex())
                
                Spacer()
            }.navigationTitle(viewModel.name != "" ? viewModel.name + "'s Profile" : "")
        }.navigationViewStyle(.stack)
    }
}

struct ImageWithDescriptionView: View {
    var profileDescription: String
    var vm: ProfileDetailViewModel
    var selectedPicture: Int
    
    var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                AsyncImage(
                    placeholder: {Text("No picture yet!")},
                    vm: vm,
                    selectedPicture: selectedPicture
                )
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 300, alignment: .center).cornerRadius(30).shadow(color: .white, radius: 10)
            } else {
                // Fallback on earlier versions
                AsyncImage(
                    placeholder: {Text("No picture yet!")},
                    vm: vm,
                    selectedPicture: selectedPicture
                )
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300, alignment: .center).cornerRadius(30).shadow(color: .white, radius: 5)
            }
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
        content.onTapGesture {
            loader.handleTapOnImage()
        }
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



//struct ProfileDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileDetailView(navigationTitle: "Profile Pictures")
//    }
//}
