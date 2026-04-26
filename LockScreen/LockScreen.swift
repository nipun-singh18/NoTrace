import SwiftUI

struct LockScreen: View {
    @EnvironmentObject var gameState: GameState
    @State private var password = ""
    @State private var wrongAttempts = 0
    @State private var showHint = false
    @State private var showEmergency = false
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
           
            Color.black.ignoresSafeArea()
            Image(systemName: "pawprint.fill")
                .resizable().scaledToFit().frame(width: 350)
                .foregroundColor(.white.opacity(0.05))
                .offset(y: 50)
            
           
            VStack(spacing: 20) {
                Image(systemName: "lock.fill").font(.title3).foregroundColor(.white).padding(.top, 50)
                
                VStack(spacing: 5) {
                    Text("12:00").font(.system(size: 90, weight: .thin)).foregroundColor(.white)
                    Text("Wednesday, Feb 25").font(.title3).fontWeight(.medium).foregroundColor(.white.opacity(0.8))
                }
                
                Spacer().frame(height: 30)
              
                if showHint {
                    Text("HINT: Rex is 8 today (2026). Calculate birth year.")
                        .font(.subheadline).fontWeight(.bold).foregroundColor(.red)
                        .padding().background(Color.black.opacity(0.8)).cornerRadius(12)
                } else {
                    HStack(spacing: 15) {
                        Image(systemName: "calendar").resizable().frame(width: 40, height: 40)
                            .foregroundColor(.black).padding(8).background(Color.white).cornerRadius(8)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Rex's 8th Birthday! 🎂").font(.headline).foregroundColor(.white)
                            Text("Don't forget treats.").font(.subheadline).foregroundColor(.white.opacity(0.9))
                        }
                        Spacer()
                    }
                    .padding(15).background(.ultraThinMaterial).cornerRadius(18).padding(.horizontal, 20)
                }
                
                Spacer()
                
              
                HStack(spacing: 25) {
                    ForEach(0..<4) { i in
                        Circle()
                            .fill(password.count > i ? Color.white : Color.clear)
                            .frame(width: 12, height: 12)
                            .overlay(Circle().stroke(Color.white, lineWidth: 1.5))
                    }
                }
                .modifier(ShakeEffect(animatableData: shakeOffset))
                .padding(.bottom, 30)
                
               
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 25) {
                    ForEach(1...9, id: \.self) { num in
                        KeypadButton(text: "\(num)", action: { enterDigit("\(num)") })
                            .keyboardShortcut(KeyEquivalent(Character("\(num)")), modifiers: [])
                    }
                    Button("Emergency") { showEmergency = true }
                        .font(.system(size: 14, weight: .bold)).foregroundColor(.white).offset(y: 10)
                    KeypadButton(text: "0", action: { enterDigit("0") }).keyboardShortcut("0", modifiers: [])
                    Button(action: { if !password.isEmpty { password.removeLast() } }) {
                        Image(systemName: "delete.left.fill").font(.title2).foregroundColor(.white)
                    }.offset(y: 10).keyboardShortcut(.delete, modifiers: [])
                }
                .padding(.horizontal, 40).padding(.bottom, 50)
            }
        }
        .sheet(isPresented: $showEmergency) {
            EmergencyView()
        }
    }
    
    func enterDigit(_ digit: String) {
        if password.count < 4 {
            password.append(digit)
            if password.count == 4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if password == "2018" {
                        withAnimation { gameState.isPhoneUnlocked = true }
                    } else {
                        wrongAttempts += 1
                        password = ""
                        withAnimation { shakeOffset = 10 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { withAnimation { shakeOffset = 0 } }
                        if wrongAttempts >= 5 { withAnimation { showHint = true } }
                    }
                }
            }
        }
    }
}



struct KeypadButton: View {
    let text: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle().fill(Color.white.opacity(0.15)).frame(width: 75, height: 75)
                Text(text).font(.system(size: 32, weight: .regular)).foregroundColor(.white)
            }
        }
    }
}

struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: 10 * sin(animatableData * .pi * 2), y: 0))
    }
}


struct EmergencyView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedMessage: String?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Tap a contact to read transcript")) {
                    Button {
                        selectedMessage = "Mom: 'Beta? Please pick up milk on your way back. And are you eating properly? Call me back!'"
                    } label: {
                        Label("Mom", systemImage: "person.circle.fill")
                    }
                    
                    Button {
                        selectedMessage = "Sarah (Colleague): 'Hey, don't forget the **PROJECT X** files for the meeting! The boss is waiting.'"
                    } label: {
                        Label("Sarah (Colleague)", systemImage: "briefcase.fill")
                    }
                    
                    Button {
                        selectedMessage = "Pizza Place: 'Yo, your Extra Spicy Pepperoni is getting cold. You coming or what?'"
                    } label: {
                        Label("Pizza Place", systemImage: "fork.knife.circle.fill")
                    }
                }
                
                // The Text Display Area
                if let message = selectedMessage {
                    VStack(alignment: .leading) {
                        Text("TRANSCRIPT:")
                            .font(.caption).bold().foregroundColor(.gray)
                        Text(message)
                            .font(.body).italic().padding(.top, 2)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(10)
                    .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Emergency")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") { dismiss() }
                }
            }
        }
    }
}
