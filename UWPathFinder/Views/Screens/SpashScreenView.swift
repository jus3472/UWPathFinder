import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var pathOpacity = 0.0
    @State private var dotPosition = CGPoint(x: 0, y: 0)
    @State private var showMainView = false
    
    private let uwRed = Color(red: 197/255, green: 5/255, blue: 12/255)
    
    var body: some View {
        if showMainView {
            MainView()
        } else {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack {
                    // Path animation with dot
                    ZStack {
                        // Simple path between points
                        Path { path in
                            path.move(to: CGPoint(x: 50, y: 100))
                            path.addLine(to: CGPoint(x: 150, y: 150))
                            path.addLine(to: CGPoint(x: 250, y: 100))
                            path.addLine(to: CGPoint(x: 350, y: 150))
                        }
                        .stroke(uwRed, lineWidth: 3)
                        .opacity(pathOpacity)
                        
                        // Moving dot
                        Circle()
                            .fill(uwRed)
                            .frame(width: 15, height: 15)
                            .position(dotPosition)
                    }
                    .frame(height: 200)
                    
                    Text("UW Path Finder")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundColor(uwRed)
                        .opacity(pathOpacity)
                }
            }
            .onAppear {
                // Animate the path appearing
                withAnimation(.easeIn(duration: 1.0)) {
                    pathOpacity = 1.0
                }
                
                // Animate the dot moving along the path
                let points = [
                    CGPoint(x: 50, y: 100),
                    CGPoint(x: 150, y: 150),
                    CGPoint(x: 250, y: 100),
                    CGPoint(x: 350, y: 150)
                ]
                
                dotPosition = points[0]
                
                for (index, point) in points.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            dotPosition = point
                        }
                    }
                }
                
                // Transition to main view after animations
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        showMainView = true
                    }
                }
            }
        }
    }
}
