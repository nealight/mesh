//
//  SettingsView.swift
//  mesh
//
//  Created by Yi Xu on 12/31/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject public var viewModel: SettingsViewModel
    @Environment(\.presentationMode) private var presentationStatus
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Displayed Name")) {
                    TextField("", text: $viewModel.profileInfo.name).submitLabel(.done)
                }
                
                Section(header: Text("LinkedIn or Your Personal Website")) {
                        TextField("Website Link", text: $viewModel.profileInfo.linkedInLink).submitLabel(.done)
                }
                    
            }.background(Color.gray).navigationTitle("Settings").toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button("Save") {
                        viewModel.updateProfileInfo()
                        self.presentationStatus.wrappedValue.dismiss()
                    }
                })
            }
        }.navigationViewStyle(.stack)
    }
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        viewModel.loadProfileInfo()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
