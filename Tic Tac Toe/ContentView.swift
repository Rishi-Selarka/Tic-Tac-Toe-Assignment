import SwiftUI

struct ContentView: View {
    @StateObject private var gameModel = GameModel()
    @State private var showConfetti = false
    @State private var confettiKey = UUID()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.0, green: 0.0, blue: 0.15),
                    Color(red: 0.0, green: 0.05, blue: 0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                scoreboardView
                    .padding(.top, 10)
                
                turnIndicator
                
                gameBoard
                    .padding(.horizontal)
                
                resetButton
                
                gridSizeSelector
                    .padding(.bottom, 20)
                
                Spacer()
            }
            
            if showConfetti {
                ConfettiView()
                    .id(confettiKey)
                    .allowsHitTesting(false)
            }
        }
        .onChange(of: gameModel.gameState) { oldValue, newValue in
            if case .won = newValue {
                showConfetti = true
                confettiKey = UUID()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    showConfetti = false
                }
            }
        }
    }
    
    private var scoreboardView: some View {
        HStack(spacing: 30) {
            VStack(spacing: 8) {
                Text("Player X")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                
                Text("\(gameModel.xScore)")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .red.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .contentTransition(.numericText())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.red.opacity(0.3),
                                Color.red.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(
                                LinearGradient(
                                    colors: [.red.opacity(0.6), .red.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
            
            Text("VS")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("Player O")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                
                Text("\(gameModel.oScore)")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .contentTransition(.numericText())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.3),
                                Color.blue.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(
                                LinearGradient(
                                    colors: [.blue.opacity(0.6), .blue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
        }
        .padding(.horizontal, 20)
    }
    
    private var gridSizeSelector: some View {
        HStack(spacing: 15) {
            ForEach([3, 4, 5], id: \.self) { size in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        gameModel.gridSize = size
                    }
                }) {
                    Text("\(size)×\(size)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(
                            isGameInProgress ? .white.opacity(0.3) :
                            (gameModel.gridSize == size ? .white : .white.opacity(0.7))
                        )
                        .frame(width: 60, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    isGameInProgress ?
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.05), Color.white.opacity(0.02)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) :
                                    (gameModel.gridSize == size ?
                                    LinearGradient(
                                        colors: [.purple.opacity(0.6), .purple.opacity(0.4)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) :
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    isGameInProgress ? Color.white.opacity(0.1) :
                                    (gameModel.gridSize == size ?
                                    Color.purple.opacity(0.8) :
                                    Color.white.opacity(0.2)),
                                    lineWidth: gameModel.gridSize == size ? 2 : 1
                                )
                        )
                }
                .disabled(isGameInProgress)
            }
        }
    }
    
    private var isGameInProgress: Bool {
        for row in gameModel.board {
            for cell in row {
                if cell != nil {
                    return true
                }
            }
        }
        return false
    }
    
    private var turnIndicator: some View {
        Group {
            switch gameModel.gameState {
            case .playing:
                HStack(spacing: 10) {
                    Text("Current Turn:")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(gameModel.currentPlayer.rawValue)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    gameModel.currentPlayer.color,
                                    gameModel.currentPlayer.color.opacity(0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            gameModel.currentPlayer.color.opacity(0.3),
                                            gameModel.currentPlayer.color.opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    Circle()
                                        .stroke(
                                            gameModel.currentPlayer.color.opacity(0.6),
                                            lineWidth: 2
                                        )
                                )
                        )
                }
                .transition(.scale.combined(with: .opacity))
                
            case .won(let player):
                Text("\(player.rawValue) Wins! 🎉")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                player.color,
                                player.color.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .transition(.scale.combined(with: .opacity))
                
            case .draw:
                Text("It's a Draw! 🤝")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: gameModel.gameState)
    }
    
    private var gameBoard: some View {
        VStack(spacing: 8) {
            ForEach(0..<gameModel.gridSize, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<gameModel.gridSize, id: \.self) { col in
                        let index = row * gameModel.gridSize + col
                        let isWinning = gameModel.winningCells.contains(index)
                        
                        GameCellView(
                            player: gameModel.board[row][col],
                            isWinning: isWinning
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                gameModel.makeMove(row: row, col: col)
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.15),
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.4),
                                    Color.white.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        )
    }
    
    private var resetButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                gameModel.resetGame()
                showConfetti = false
            }
        }) {
            HStack(spacing: 10) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Reset Board")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: 200)
            .padding(.vertical, 15)
            .background(
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.7),
                        Color.purple.opacity(0.5)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.5),
                                Color.white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: Color.purple.opacity(0.5), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
}
