import SwiftUI

struct ContentView: View {
    @StateObject var gameState = GameState()
    
    var body: some View {
        ZStack {
            if gameState.isPhoneUnlocked {
                HomeScreen()
            } else {
                LockScreen()
            }
        }
        .environmentObject(gameState)
        .preferredColorScheme(.dark)
    }
}
