import SwiftUI

struct GameCellView: View {
    let player: Player?
    let isWinning: Bool
    let action: () -> Void
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: isWinning ? 
                                [player?.color ?? .gray, player?.color.opacity(0.6) ?? .gray] :
                                [Color.white.opacity(0.2), Color.white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isWinning ? 
                                    player?.color ?? .clear :
                                    Color.white.opacity(0.3),
                                lineWidth: isWinning ? 3 : 1
                            )
                    )
                    .shadow(
                        color: isWinning ? 
                            (player?.color.opacity(0.5) ?? .clear) :
                            Color.black.opacity(0.2),
                        radius: isWinning ? 10 : 5
                    )
                
                if let player = player {
                    Text(player.rawValue)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    player.color,
                                    player.color.opacity(0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(player != nil)
        .onAppear {
            if player != nil {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
        .onChange(of: player) { oldValue, newValue in
            if newValue != nil {
                scale = 0.5
                opacity = 0.0
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
        .onChange(of: isWinning) { oldValue, newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true)) {
                }
            }
        }
    }
}

