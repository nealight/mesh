//
//  SettingsView.swift
//  mesh
//
//  Created by Yi Xu on 12/31/21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Group {
                Text("Hey!")
            }.foregroundColor(.white).background(Color.gray).frame(width: 200, height: 200, alignment: .center).navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
