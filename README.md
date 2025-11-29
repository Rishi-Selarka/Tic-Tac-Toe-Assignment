# 🎮 Tic Tac Toe Game

A beautiful, feature-rich Tic Tac Toe game built with SwiftUI for iOS. Experience smooth animations, confetti celebrations, and an elegant dark theme interface.

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![iOS](https://img.shields.io/badge/iOS-14.0+-blue.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-2.0+-green.svg)
![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)

---

## ✨ Features

- 🎯 **Multiple Grid Sizes** - Play on 3×3, 4×4, or 5×5 grids
- 👥 **Two-Player Mode** - Classic X vs O gameplay
- 🎨 **Beautiful UI** - Dark black and blue gradient theme with smooth animations
- 🎊 **Confetti Celebration** - Animated confetti when a player wins
- 📊 **Scoreboard** - Track wins for both players (resets on app close)
- 🎭 **Win Detection** - Automatic win/draw detection with highlighted winning cells
- 🔄 **Reset Functionality** - Reset the board anytime during gameplay
- 🚫 **Smart Grid Locking** - Grid size can only be changed before the game starts
- ⚡ **Smooth Animations** - Spring animations for all interactions

---

## 📋 Requirements

- **iOS 14.0+**
- **Xcode 12.0+**
- **Swift 5.9+**
- **macOS** (for development)

---

## 🚀 Getting Started

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Rishi-Selarka/Tic-Tac-Toe-Assignment.git
   cd Tic-Tac-Toe-Assignment
   ```

2. **Open the project**
   - Open `Tic Tac Toe.xcodeproj` in Xcode
   - Or double-click the `.xcodeproj` file in Finder

3. **Select your target device**
   - Choose a simulator from the device menu in Xcode
   - Or connect your physical iOS device

4. **Build and Run**
   - Press `⌘ + R` or click the "Run" button
   - Wait for the app to build and launch

### Running on a Physical Device

1. **Connect your iPhone/iPad**
   - Use a USB cable to connect your device to your Mac
   - Unlock your device and trust the computer if prompted

2. **Configure Signing**
   - In Xcode, select your project in the navigator
   - Go to the "Signing & Capabilities" tab
   - Select your Apple Developer Team (or use your personal team)
   - Xcode will automatically manage provisioning

3. **Select your device**
   - In the device menu (next to the Run button), select your connected device
   - If you see a warning, click "Fix Issue" and follow the prompts

4. **Build and Run**
   - Press `⌘ + R` to build and install on your device
   - The app will launch automatically on your device

> **Note:** For physical devices, you need an Apple Developer account (free account works for personal development).

---

## 🎮 How to Play

1. **Select Grid Size**
   - Choose between 3×3, 4×4, or 5×5 grids
   - Grid size can only be changed before making any moves

2. **Make Moves**
   - Player X (Red) starts first
   - Tap any empty cell to place your mark
   - Players alternate turns automatically

3. **Win Conditions**
   - Get a full row, column, or diagonal to win
   - The game automatically detects wins and draws
   - Winning cells are highlighted with a glow effect

4. **Reset**
   - Tap "Reset Board" to start a new game
   - Scores are maintained until the app is closed

---

## 🏗️ Project Structure

```
Tic Tac Toe/
├── Tic Tac Toe/
│   ├── GameModel.swift          # Game logic and state management
│   ├── GameCellView.swift        # Individual cell component
│   ├── ConfettiView.swift        # Confetti particle system
│   ├── ContentView.swift         # Main game interface
│   ├── Tic_Tac_ToeApp.swift     # App entry point
│   └── Assets.xcassets/          # App icons and assets
├── Tic Tac ToeTests/             # Unit tests
├── Tic Tac ToeUITests/           # UI tests
└── README.md                     # This file
```

---

## 💻 Code Snippets

### Game Model

The `GameModel` class manages all game state and logic:

```swift
class GameModel: ObservableObject {
    @Published var gridSize: Int = 3
    @Published var board: [[Player?]] = []
    @Published var currentPlayer: Player = .x
    @Published var gameState: GameState = .playing
    @Published var xScore: Int = 0
    @Published var oScore: Int = 0
    @Published var winningCells: Set<Int> = []
    
    func makeMove(row: Int, col: Int) {
        guard case .playing = gameState,
              board[row][col] == nil else {
            return
        }
        // Game logic...
    }
}
```

### Confetti Animation

The confetti effect uses SwiftUI's `TimelineView` for smooth animations:

```swift
struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        TimelineView(.animation) { context in
            ZStack {
                ForEach(particles) { particle in
                    // Render particles with physics
                }
            }
        }
    }
}
```

### Cell Animation

Each cell animates when a move is made:

```swift
struct GameCellView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        Button(action: action) {
            // Cell UI with spring animation
        }
        .onChange(of: player) { oldValue, newValue in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
```

---

## 🎨 Design Features

- **Dark Theme**: Black and blue gradient background for a modern look
- **Color Coding**: Red for Player X, Blue for Player O
- **Gradient Effects**: Linear gradients throughout the UI
- **Smooth Transitions**: Spring animations for all state changes
- **Visual Feedback**: Winning cells glow with player colors

---

## 🔧 Technical Details

### Architecture
- **MVVM Pattern**: Model-View-ViewModel architecture
- **ObservableObject**: Reactive state management with `@Published` properties
- **SwiftUI**: Modern declarative UI framework

### Key Components
- `GameModel`: Centralized game state and logic
- `GameCellView`: Reusable cell component with animations
- `ConfettiView`: Custom particle system for celebrations
- `ContentView`: Main view orchestrating all components

### Win Detection Algorithm
The game checks for wins in four directions:
1. **Rows**: Horizontal lines
2. **Columns**: Vertical lines
3. **Main Diagonal**: Top-left to bottom-right
4. **Anti-Diagonal**: Top-right to bottom-left

---

## 📱 Screenshots

*Add screenshots of your app here to showcase the beautiful UI*

---

## 🛠️ Troubleshooting

### Build Errors
- Ensure you're using Xcode 12.0 or later
- Clean build folder: `⌘ + Shift + K`, then `⌘ + B`

### Device Connection Issues
- Make sure your device is unlocked
- Trust the computer on your device
- Check that your Apple ID is signed in Xcode

### Signing Issues
- Go to Xcode → Preferences → Accounts
- Add your Apple ID if not already added
- Select "Automatically manage signing" in project settings

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

## 👤 Author

**Rishi Selarka**

- GitHub: [@Rishi-Selarka](https://github.com/Rishi-Selarka)
- Repository: [Tic-Tac-Toe-Assignment](https://github.com/Rishi-Selarka/Tic-Tac-Toe-Assignment)

---

## 🙏 Acknowledgments

- Built with SwiftUI and Swift
- Inspired by classic Tic Tac Toe gameplay
- Modern iOS design principles

---

## 📈 Future Enhancements

Potential features for future versions:
- [ ] Single-player mode with AI
- [ ] Difficulty levels
- [ ] Persistent scoreboard (using UserDefaults or Core Data)
- [ ] Sound effects
- [ ] Haptic feedback
- [ ] Game history
- [ ] Multiplayer over network

---

**Enjoy playing! 🎉**
