import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var gameState: GameState
    @State private var showApp: String? = nil
    @State private var showLockedAlert = false
    @State private var lockedMessage = ""
    
    var body: some View {
        ZStack {
           
            LinearGradient(colors: [Color.black, Color.purple.opacity(0.6)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack {
                Spacer()
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 25) {
                    
                  
                    AppButton(name: "Messages", icon: "message.fill", color: .green) { showApp = "Messages" }
                    
                    
                    AppButton(name: "Notes", icon: "note.text", color: .yellow) { showApp = "Notes" }
                    
                    
                    AppButton(name: "Photos", icon: "photo", color: .white) {
                        if gameState.currentLevel >= 1 { showApp = "Photos" }
                        else { lockedMessage = "Bruh wait, first complete Level 1"; showLockedAlert = true }
                    }
                    
                   
                    AppButton(name: "Settings", icon: "gear", color: .gray) {
                        if gameState.currentLevel >= 2 { showApp = "Settings" }
                        else { lockedMessage = "System Encrypted. Complete Level 2"; showLockedAlert = true }
                    }
                }
                .padding()
            }
        }
        .sheet(item: $showApp) { app in
            if app == "Messages" { MessagesApp() }
            if app == "Notes" { NotesApp() }
            if app == "Photos" { PhotosApp() }
            if app == "Settings" { SettingsApp() }
        }
        .alert(lockedMessage, isPresented: $showLockedAlert) { Button("OK", role: .cancel) { } }
    }
}


extension String: Identifiable {
    public var id: String { self }
}

struct AppButton: View {
    let name: String; let icon: String; let color: Color; let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12).fill(color).frame(width: 60, height: 60)
                    Image(systemName: icon).font(.title).foregroundColor(color == .white ? .black : .white)
                }
                Text(name).font(.caption).foregroundColor(.white)
            }
        }
    }
}
