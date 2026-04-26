import SwiftUI

struct PhotosApp: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Evidence #1").font(.headline)
                
                
                Image("image18")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                
                Text("Calculate carefully.").font(.caption).padding(.top)
                Spacer()
            }
            .navigationTitle("Photos")
            .toolbar { Button("Close") { dismiss() } }
        }
    }
}
