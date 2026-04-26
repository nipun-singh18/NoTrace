import SwiftUI

struct HackerGameView: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    
    @State private var score = 0
    @State private var time = 30
    @State private var packets: [Packet] = []
    @State private var gameOver = false
    @State private var victory = false
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
  
   
    let spawner = Timer.publish(every: 0.35, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if !victory && !gameOver {
                VStack {
                    HStack {
                       
                        Text("HACKING: \(score)/18").foregroundColor(.green).font(.monospaced(.headline)())
                        Spacer()
                        Text("TIME: \(time)").foregroundColor(.red).font(.monospaced(.headline)())
                    }.padding()
                    Spacer()
                }
                
                ForEach(packets) { packet in
                    Circle().fill(packet.isVirus ? Color.red : Color.green).frame(width: 50, height: 50)
                        .position(x: packet.x, y: packet.y)
                        .onTapGesture { handleTap(packet) }
                }
            }
            
           
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.top, 50)
                            .padding(.trailing, 20)
                    }
                }
                Spacer()
            }
            .zIndex(100)
            
            if victory {
                VStack(spacing: 20) {
                    Text("LEVEL 1 CLEARED").font(.largeTitle).bold().foregroundColor(.green)
                    Button("Continue") {
                        gameState.currentLevel = max(gameState.currentLevel, 1)
                        dismiss()
                    }.padding().background(Color.white).cornerRadius(10)
                }
            }
            
            if gameOver {
                VStack {
                    Text("MISSION FAILED").font(.largeTitle).foregroundColor(.red)
                    Button("Retry System") { reset() }.padding().background(Color.white).cornerRadius(10)
                }
            }
        }
        .onReceive(timer) { _ in
            if !victory && !gameOver {
                if time > 0 {
                    time -= 1
                    updatePositions()
                } else {
                    gameOver = true
                }
            }
        }
        .onReceive(spawner) { _ in
            if !victory && !gameOver { spawnPacket() }
        }
    }
    
    func spawnPacket() {
        let x = CGFloat.random(in: 50...UIScreen.main.bounds.width-50)
        
       
        let isVirus = Bool.random() && Bool.random() && Bool.random()
        
        packets.append(Packet(id: UUID(), x: x, y: -50, isVirus: isVirus))
    }
    
    func updatePositions() {
        for i in 0..<packets.count {
            packets[i].y += 50
        }
    }
    
    func handleTap(_ packet: Packet) {
        if let idx = packets.firstIndex(where: {$0.id == packet.id}) {
            packets.remove(at: idx)
            if packet.isVirus {
                score -= 2
            } else {
                score += 1
            }
            
            if score >= 18 { victory = true }
        }
    }
    
    func reset() {
        score = 0
        time = 30
        packets.removeAll()
        gameOver = false
    }
}

struct Packet: Identifiable {
    var id: UUID
    var x: CGFloat
    var y: CGFloat
    var isVirus: Bool
}
