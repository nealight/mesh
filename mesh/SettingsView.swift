//
//  SettingsView.swift
//  mesh
//
//  Created by Yi Xu on 12/31/21.
//

import SwiftUI

struct SettingsView: View {
    @State private var displayedName = ""
    @State private var linkedInLink = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Displayed Name", text: $displayedName)
                    TextField("Website Link", text: $linkedInLink)
                }
            }.background(Color.gray).navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
