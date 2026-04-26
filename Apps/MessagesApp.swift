import SwiftUI

struct MessagesApp: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
            
                NavigationLink(destination: ChatDetailView(sender: "Mom", message: "Hello beta?\nPlease pick up milk on your way back! 🥛\nAnd don't forget Rex's treats.")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("Mom").bold()
                            Text("Pick up milk!").font(.caption).foregroundColor(.gray)
                        }
                    }
                }

                
                NavigationLink(destination: ChatDetailView(sender: "Unknown", message: "⚠️ DECRYPTED MESSAGE\n\nI locked the location in the Notes app.\n\nThe Code is: 1999\n(It's the year the company started).\n\nHurry!")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Unknown").bold()
                            Text("Code for Notes is 1999...").font(.caption).foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Messages")
            .toolbar {
                Button("Close") { dismiss() }
            }
        }
    }
}


struct ChatDetailView: View {
    var sender: String
    var message: String

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(message)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                Spacer()
            }
            .padding()
            Spacer()
        }
        .navigationTitle(sender)
    }
}
