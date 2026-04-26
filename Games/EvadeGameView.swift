import SwiftUI

struct EvadeGameView: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    
    @State private var playerPos = CGPoint(x: 200, y: 400)
    @State private var enemies: [CGPoint] = []
    @State private var timeRemaining = 18.0
    @State private var gameOver = false
    @State private var victory = false
    @State private var isSlowMo = false
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.6, blue: 0.3).ignoresSafeArea()
            
            if !victory && !gameOver {
                VStack {
                    HStack {
                        Text("SURVIVE: \(Int(timeRemaining))").font(.system(size: 30, weight: .black))
                        Spacer()
                    }.padding()
                    Spacer()
                    
                    
                    Button(action: {}) {
                        Text("HOLD FOR SLOW MO")
                            .font(.caption).bold()
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in isSlowMo = true }
                            .onEnded { _ in isSlowMo = false }
                    )
                    .padding(.bottom, 50)
                }
                
               
                Circle().fill(Color.blue).frame(width: 30, height: 30)
                    .position(playerPos)
                    .gesture(DragGesture().onChanged { value in playerPos = value.location })
                
                
                ForEach(0..<enemies.count, id: \.self) { i in
                    Rectangle().fill(Color.red).frame(width: 40, height: 40)
                        .position(enemies[i])
                }
            }
            
           
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black.opacity(0.6))
                            .padding(.top, 50)
                            .padding(.trailing, 20)
                    }
                }
                Spacer()
            }
            .zIndex(100)
            if victory {
                VStack(spacing: 20) {
                    Text("CONGRATULATIONS\nGENTLEMAN 👏").font(.largeTitle).bold().multilineTextAlignment(.center)
                    Text("You Saved Rex's Mobile").padding()
                    Button("Finish") { exit(0) }.padding().background(Color.black).foregroundColor(.white).cornerRadius(10)
                }
            }
            
            if gameOver {
                VStack {
                    Text("CAUGHT!").font(.largeTitle).bold().foregroundColor(.red)
                    Button("Retry") { reset() }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }
        }
        .onReceive(timer) { _ in
            if !victory && !gameOver {
                updateGame()
            }
        }
    }
    
   
    
    func updateGame() {
       
        
        let speed = isSlowMo ? 2.0 : 8.0
        let dt = 0.05
    
        if isSlowMo {
            timeRemaining -= (dt * 0.2)
        } else {
            timeRemaining -= dt
        }
        
        if timeRemaining <= 0 { victory = true }
        
       
        if Int(timeRemaining * 10) % 20 == 0 && enemies.count < 8 {
             enemies.append(CGPoint(x: CGFloat.random(in: 0...400), y: -50))
        }
        
        
        for i in 0..<enemies.count {
           
            if i < enemies.count {
                let dx = playerPos.x - enemies[i].x
                let dy = playerPos.y - enemies[i].y
                let dist = sqrt(dx*dx + dy*dy)
                
                if dist < 40 { gameOver = true } 
                
                if dist > 0 {
                    enemies[i].x += (dx/dist) * speed
                    enemies[i].y += (dy/dist) * speed
                }
            }
        }
    }
    
    func reset() {
        timeRemaining = 18
        enemies = []
        playerPos = CGPoint(x: 200, y: 400)
        gameOver = false
    }
}
