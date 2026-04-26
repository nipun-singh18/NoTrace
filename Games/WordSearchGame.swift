import SwiftUI


struct GridCoord: Hashable {
    let row: Int
    let col: Int
}

struct TargetWord {
    let text: String
    let color: Color
    let coords: Set<GridCoord>
}

struct WordSearchGame: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    
  
    @State private var foundWords: Set<String> = []
    @State private var currentDragSelection: Set<GridCoord> = []
   
    let gridRows = [
        ["N", "I", "P", "U", "N"],
        ["R", "E", "X", "A", "T"],
        ["T", "R", "A", "C", "E"],
        ["S", "A", "R", "A", "H"],
        ["T", "E", "C", "H", "O"],
        ["S", "W", "I", "F", "T"]
    ]
    
    let targets: [TargetWord] = [
        TargetWord(text: "NIPUN", color: .red, coords: [GridCoord(row: 0, col: 0), GridCoord(row: 0, col: 1), GridCoord(row: 0, col: 2), GridCoord(row: 0, col: 3), GridCoord(row: 0, col: 4)]),
        TargetWord(text: "REX", color: .green, coords: [GridCoord(row: 1, col: 0), GridCoord(row: 1, col: 1), GridCoord(row: 1, col: 2)]),
        TargetWord(text: "TRACE", color: .blue, coords: [GridCoord(row: 2, col: 0), GridCoord(row: 2, col: 1), GridCoord(row: 2, col: 2), GridCoord(row: 2, col: 3), GridCoord(row: 2, col: 4)]),
        TargetWord(text: "SARAH", color: .purple, coords: [GridCoord(row: 3, col: 0), GridCoord(row: 3, col: 1), GridCoord(row: 3, col: 2), GridCoord(row: 3, col: 3), GridCoord(row: 3, col: 4)]),
        TargetWord(text: "TECH", color: .cyan, coords: [GridCoord(row: 4, col: 0), GridCoord(row: 4, col: 1), GridCoord(row: 4, col: 2), GridCoord(row: 4, col: 3)]),
        TargetWord(text: "SWIFT", color: .orange, coords: [GridCoord(row: 5, col: 0), GridCoord(row: 5, col: 1), GridCoord(row: 5, col: 2), GridCoord(row: 5, col: 3), GridCoord(row: 5, col: 4)])
    ]
    
    let tileSize: CGFloat = 55
    let spacing: CGFloat = 5
    let rows = 6
    let cols = 5
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.2).ignoresSafeArea()
            
            VStack {
                Text("LEVEL 2: BRAND HUNT")
                    .font(.headline).bold()
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
               
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(targets, id: \.text) { word in
                        Text(word.text)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(foundWords.contains(word.text) ? word.color : .gray)
                            .strikethrough(foundWords.contains(word.text))
                            .padding(5)
                    }
                }.padding()
                
                Spacer()
                
               
                ZStack {
                    VStack(spacing: spacing) {
                        ForEach(0..<rows, id: \.self) { row in
                            HStack(spacing: spacing) {
                                ForEach(0..<cols, id: \.self) { col in
                                    let coord = GridCoord(row: row, col: col)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(getTileColor(coord))
                                            .frame(width: tileSize, height: tileSize)
                                        Text(gridRows[row][col])
                                            .font(.title2).bold().foregroundColor(.white)
                                    }
                                }
                            }
                        }
                    }
                    Color.white.opacity(0.001)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let col = Int(value.location.x / (tileSize + spacing))
                                    let row = Int(value.location.y / (tileSize + spacing))
                                    if row >= 0 && row < rows && col >= 0 && col < cols {
                                        let coord = GridCoord(row: row, col: col)
                                        if !currentDragSelection.contains(coord) { currentDragSelection.insert(coord) }
                                    }
                                }
                                .onEnded { _ in checkWinCondition() }
                        )
                }
                .frame(width: (tileSize * CGFloat(cols)) + (spacing * 4), height: (tileSize * CGFloat(rows)) + (spacing * 5))
                
                Spacer()
                
                Button("Reset Selection") { currentDragSelection.removeAll() }
                    .foregroundColor(.gray).padding(.bottom)
            }
            
           
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.6))
                            .padding()
                    }
                }
                Spacer()
            }
              
            if foundWords.count == targets.count {
                VStack {
                    Text("LEVEL 2 CLEARED").font(.title).bold().foregroundColor(.green).padding()
                    Button("PROCEED TO ENDGAME") {
                        gameState.currentLevel = max(gameState.currentLevel, 2)
                        dismiss()
                    }
                    .padding().background(Color.white).foregroundColor(.black).cornerRadius(10)
                }
                .padding().background(Color.black.opacity(0.9)).cornerRadius(20)
            }
        }
    }
    
    func getTileColor(_ coord: GridCoord) -> Color {
        for word in targets {
            if foundWords.contains(word.text) && word.coords.contains(coord) { return word.color }
        }
        if currentDragSelection.contains(coord) { return .yellow }
        return Color.white.opacity(0.1)
    }
    
    func checkWinCondition() {
        for target in targets {
            if currentDragSelection == target.coords { foundWords.insert(target.text) }
        }
        currentDragSelection.removeAll()
    }
}
