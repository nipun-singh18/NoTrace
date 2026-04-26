import SwiftUI

@MainActor
class GameState: ObservableObject {
   
    @Published var isPhoneUnlocked = false
    @Published var currentLevel = 0 
}
