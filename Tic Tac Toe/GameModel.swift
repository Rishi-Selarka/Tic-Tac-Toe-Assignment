import SwiftUI
import Combine

enum Player: String {
    case x = "X"
    case o = "O"
    
    var color: Color {
        switch self {
        case .x:
            return .red
        case .o:
            return .blue
        }
    }
}

enum GameState: Equatable {
    case playing
    case won(Player)
    case draw
}

class GameModel: ObservableObject {
    @Published var gridSize: Int = 3 {
        didSet {
            resetGame()
        }
    }
    
    @Published var board: [[Player?]] = []
    @Published var currentPlayer: Player = .x
    @Published var gameState: GameState = .playing
    @Published var xScore: Int = 0
    @Published var oScore: Int = 0
    @Published var winningCells: Set<Int> = []
    
    private var firstPlayer: Player = .x
    
    init() {
        initializeBoard()
    }
    
    func initializeBoard() {
        board = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)
        gameState = .playing
        winningCells.removeAll()
    }
    
    func resetGame() {
        initializeBoard()
        firstPlayer = firstPlayer == .x ? .o : .x
        currentPlayer = firstPlayer
    }
    
    func makeMove(row: Int, col: Int) {
        guard case .playing = gameState,
              board[row][col] == nil else {
            return
        }
        
        board[row][col] = currentPlayer
        
        if checkWin(row: row, col: col) {
            gameState = .won(currentPlayer)
            if currentPlayer == .x {
                xScore += 1
            } else {
                oScore += 1
            }
        } else if isBoardFull() {
            gameState = .draw
        } else {
            currentPlayer = currentPlayer == .x ? .o : .x
        }
    }
    
    private func checkWin(row: Int, col: Int) -> Bool {
        let player = board[row][col]!
        
        var rowWin = true
        var rowCells = Set<Int>()
        for c in 0..<gridSize {
            rowCells.insert(row * gridSize + c)
            if board[row][c] != player {
                rowWin = false
                break
            }
        }
        if rowWin {
            winningCells = rowCells
            return true
        }
        
        var colWin = true
        var colCells = Set<Int>()
        for r in 0..<gridSize {
            colCells.insert(r * gridSize + col)
            if board[r][col] != player {
                colWin = false
                break
            }
        }
        if colWin {
            winningCells = colCells
            return true
        }
        
        if row == col {
            var diagWin = true
            var diagCells = Set<Int>()
            for i in 0..<gridSize {
                diagCells.insert(i * gridSize + i)
                if board[i][i] != player {
                    diagWin = false
                    break
                }
            }
            if diagWin {
                winningCells = diagCells
                return true
            }
        }
        
        if row + col == gridSize - 1 {
            var antiDiagWin = true
            var antiDiagCells = Set<Int>()
            for i in 0..<gridSize {
                antiDiagCells.insert(i * gridSize + (gridSize - 1 - i))
                if board[i][gridSize - 1 - i] != player {
                    antiDiagWin = false
                    break
                }
            }
            if antiDiagWin {
                winningCells = antiDiagCells
                return true
            }
        }
        
        return false
    }
    
    private func isBoardFull() -> Bool {
        for row in board {
            for cell in row {
                if cell == nil {
                    return false
                }
            }
        }
        return true
    }
    
    func resetScores() {
        xScore = 0
        oScore = 0
    }
}

