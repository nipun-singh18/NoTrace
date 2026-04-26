import SwiftUI

struct NotesApp: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    @State private var passwordInput = ""
    @State private var activeNote: String? = nil
    @State private var showPasswordAlert = false
    @State private var targetNote = ""
    @State private var errorShake = 0.0
    
    var body: some View {
        NavigationView {
            List {
            
                NoteRow(title: "Project X (Confidential)", locked: true, action: { unlock("ProjectX") })
                
                
                NoteRow(title: "Level 2: The Pattern", locked: true, action: { unlock("Level2") })
                
                
                NoteRow(title: "Endgame", locked: true, action: { unlock("Endgame") })
            }
            .navigationTitle("Notes")
            .toolbar { Button("Close") { dismiss() } }
            
            .overlay(
                ZStack {
                    if showPasswordAlert {
                        Color.black.opacity(0.8).ignoresSafeArea()
                        VStack(spacing: 20) {
                            Text("ENTER PASSWORD").font(.headline).foregroundColor(.white)
                            if targetNote == "Level2" && errorShake > 0 { Text("HINT: BODMAS").foregroundColor(.red) }
                            if targetNote == "Endgame" && errorShake > 0 { Text("HINT: Last 4 of Serial No.").foregroundColor(.red) }
                            
                            SecureField("Password", text: $passwordInput)
                                .padding().background(Color.white).cornerRadius(10).foregroundColor(.black).keyboardType(.numberPad)
                            
                            HStack {
                                Button("Cancel") { showPasswordAlert = false }
                                Button("Unlock") { checkPassword() }
                            }
                        }
                        .padding().background(Color.gray.opacity(0.2)).cornerRadius(20).padding()
                    }
                }
            )
            
            .sheet(item: $activeNote) { note in
                if note == "ProjectX" { HackerGameView() }
                if note == "Level2" { WordSearchGame() }
                if note == "Endgame" { EvadeGameView() }
            }
        }
    }
    
    func unlock(_ note: String) {
        targetNote = note; passwordInput = ""; showPasswordAlert = true
    }
    
    func checkPassword() {
        var correct = false
        if targetNote == "ProjectX" && passwordInput == "1999" { correct = true }
        else if targetNote == "Level2" && passwordInput == "12" { correct = true }
        else if targetNote == "Endgame" && passwordInput == "8118" { correct = true }
        
        if correct {
            showPasswordAlert = false
            activeNote = targetNote
        } else {
            withAnimation { errorShake += 1 }
        }
    }
}

struct NoteRow: View {
    let title: String; let locked: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                if locked { Image(systemName: "lock.fill").foregroundColor(.red) }
                Text(title).bold()
            }
        }
    }
}
