//
//  SettingsView.swift
//  TuneLists
//
//  Created by Gabriel Moreno on 12.12.2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Credits")) {
                    Text("App created by Gabriel Moreno")
                }
                
                Section(header: Text("Stats")) {
                    HStack {
                        Text("Total time")
                        Spacer()
                        Text("4h 20min")
                    }
                }
            }
            .navigationTitle("Settings")
            
        }
    }
}

#Preview {
    SettingsView()
}
