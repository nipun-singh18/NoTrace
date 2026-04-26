import SwiftUI

struct SettingsApp: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("About Phone")) {
                    HStack { Text("Name"); Spacer(); Text("Rex") }
                    HStack { Text("Model"); Spacer(); Text("iPhone 17 Pro") }
                    
                    HStack { Text("Serial Number"); Spacer(); Text("2188118") }
                }
            }
            .navigationTitle("Settings")
            .toolbar { Button("Close") { dismiss() } }
        }
    }
}
