//
//  SettingsView.swift
//  mesh
//
//  Created by Yi Xu on 12/31/21.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject public var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Displayed Name", text: $viewModel.profileInfo.name)
                    TextField("Website Link", text: $viewModel.profileInfo.linkedInLink)
                }
            }.background(Color.gray).navigationTitle("Settings")
        }.navigationViewStyle(.stack)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
