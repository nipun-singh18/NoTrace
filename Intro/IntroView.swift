import SwiftUI

struct IntroView: View {
    @StateObject var gameState = GameState()
    @State private var sliceOffset: CGFloat = -UIScreen.main.bounds.width
    @State private var textMaskWidth: CGFloat = 0
    @State private var showTitle = false
    @State private var titleOpacity = 0.0
    @State private var titleColor: Color = .white // 👈 FIXED: Starts White (Visible)
    @State private var showDialogue = false
    @State private var startGame = false
    
    // Dialogue States
    @State private var yesScale: CGFloat = 1.0
    @State private var noScale: CGFloat = 1.0
    @State private var funnyText = "Would you like to begin?"
    
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        if startGame {
            ContentView().environmentObject(gameState)
        } else {
            ZStack {
                Color.black.ignoresSafeArea()
                
                // STAGE 1: NIPUN PRODUCTION (Slicing)
                if !showTitle && !showDialogue {
                    ZStack {
                        VStack(spacing: 15) {
                            Text("NIPUN PRODUCTIONS").font(.custom("Courier", size: 28).bold()).tracking(2)
                            Text("PRESENTS").font(.custom("Courier", size: 18)).tracking(8)
                        }
                        .foregroundColor(.white)
                        .mask(Rectangle().frame(width: textMaskWidth).offset(x: -screenWidth/2 + textMaskWidth/2))
                        
                        Rectangle()
                            .fill(LinearGradient(colors: [.clear, .white, .clear], startPoint: .leading, endPoint: .trailing))
                            .frame(width: 150, height: 4)
                            .rotationEffect(.degrees(-15))
                            .offset(x: sliceOffset, y: 15)
                            .shadow(color: .white, radius: 10)
                    }
                }
                
                // STAGE 2: FLICKER TITLE
                if showTitle {
                    Text("NoTrace")
                        .font(.system(size: 60, weight: .heavy, design: .monospaced))
                        .foregroundColor(titleColor)
                        .opacity(titleOpacity)
                }
                
                // STAGE 3: DIALOGUE
                if showDialogue {
                    VStack(spacing: 30) {
                        Text("⚠️ DEVICE FOUND ⚠️").font(.headline).foregroundColor(.yellow).padding(.top, 50)
                        Text("Hello Mr. Detective.\nYou found this phone on the footpath.\nBe a Gentleman and help Rex.")
                            .multilineTextAlignment(.center).foregroundColor(.white).padding()
                        Spacer()
                        Text(funnyText).italic().foregroundColor(.gray).frame(height: 50)
                        HStack(spacing: 40) {
                            Button("No") {
                                withAnimation(.spring()) {
                                    noScale -= 0.3; yesScale += 0.3
                                    funnyText = "Aww hehe... Be a Gentleman! 🗿👑"
                                }
                            }
                            .padding().background(Color.gray).foregroundColor(.white).cornerRadius(10)
                            .scaleEffect(noScale).disabled(noScale < 0.2)
                            
                            Button("YES") {
                                withAnimation { startGame = true }
                            }
                            .padding().background(Color.green).foregroundColor(.white).cornerRadius(10)
                            .scaleEffect(yesScale)
                        }
                        .padding(.bottom, 50)
                    }
                }
            }
            .onAppear { runCinematicIntro() }
        }
    }
    
    func runCinematicIntro() {
                withAnimation(.easeInOut(duration: 1.5)) { sliceOffset = screenWidth; textMaskWidth = screenWidth + 50 }
        
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation { showTitle = true; titleOpacity = 1.0 }
        }
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
           
            withAnimation(.easeInOut(duration: 0.1).repeatCount(6, autoreverses: true)) {
                titleOpacity = 0.5
            }
        }
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            withAnimation { showTitle = false; showDialogue = true }
        }
    }
}
