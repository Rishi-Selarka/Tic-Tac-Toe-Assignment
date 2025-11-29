import SwiftUI

struct ConfettiParticle: Identifiable {
    let id = UUID()
    let startPosition: CGPoint
    let velocity: CGPoint
    let color: Color
    let rotationSpeed: Double
    let size: CGFloat
    let startTime: Date
}

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var startTime = Date()
    
    let colors: [Color] = [
        .red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan
    ]
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { context in
                ZStack {
                    ForEach(particles) { particle in
                        let elapsed = context.date.timeIntervalSince(particle.startTime)
                        
                        if elapsed < 3.0 {
                            let position = calculatePosition(particle: particle, elapsed: elapsed, size: geometry.size)
                            let opacity = calculateOpacity(particle: particle, elapsed: elapsed, size: geometry.size)
                            let rotation = particle.rotationSpeed * elapsed
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [particle.color, particle.color.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: particle.size, height: particle.size)
                                .position(position)
                                .rotationEffect(.degrees(rotation))
                                .opacity(opacity)
                        }
                    }
                }
            }
            .onAppear {
                startConfetti(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }
    
    func startConfetti(in size: CGSize) {
        startTime = Date()
        particles = []
        
        for _ in 0..<150 {
            let particle = ConfettiParticle(
                startPosition: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: -20
                ),
                velocity: CGPoint(
                    x: CGFloat.random(in: -80...80),
                    y: CGFloat.random(in: 150...300)
                ),
                color: colors.randomElement() ?? .red,
                rotationSpeed: Double.random(in: -200...200),
                size: CGFloat.random(in: 10...20),
                startTime: Date()
            )
            particles.append(particle)
        }
    }
    
    private func calculatePosition(particle: ConfettiParticle, elapsed: TimeInterval, size: CGSize) -> CGPoint {
        let gravity: CGFloat = 500
        let t = CGFloat(elapsed)
        
        let x = particle.startPosition.x + particle.velocity.x * t
        let y = particle.startPosition.y + particle.velocity.y * t + 0.5 * gravity * t * t
        
        return CGPoint(x: x, y: y)
    }
    
    private func calculateOpacity(particle: ConfettiParticle, elapsed: TimeInterval, size: CGSize) -> Double {
        let currentY = calculatePosition(particle: particle, elapsed: elapsed, size: size).y
        let progress = currentY / size.height
        
        if progress > 0.7 {
            return max(0, 1.0 - (progress - 0.7) / 0.3)
        }
        return 1.0
    }
}
