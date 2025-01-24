import SwiftUI

/// Allows users to find and visualize the shortest path between two campus buildings.
/// Features:
/// - Input fields for start and end buildings
/// - Animated path visualization showing:
///   - Each building in the path
///   - Walking time between buildings
///   - Total walking time
/// - Keyboard handling and error management
struct PathFinderView: View {
    /// View model for handling business logic
    @ObservedObject var viewModel: PathFinderViewModel<DijkstraGraph<String, Double>>
    @Environment(\.dismiss) private var dismiss
    
    /// State for input fields and results
    @State private var initialBuilding: String = ""
    @State private var finalBuilding: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    /// State for path visualization
    @State private var path: [String]? = nil
    @State private var walkTimes: [Double]? = nil
    @State private var totalCost: Double? = nil
    @State private var showResults = false
    @State private var animatingIndex = -1  // Controls sequential animations
    
    /// Keyboard focus states
    @FocusState private var isInitialBuildingFocused: Bool
    @FocusState private var isFinalBuildingFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                UIConstants.headerText("Find Shortest Path")
                
                // Text fields in a card-like container
                VStack(spacing: 20) {
                    // Starting building field
                    buildingTextField(
                        text: $initialBuilding,
                        placeholder: "Enter starting building name",
                        isFocused: $isInitialBuildingFocused
                    )
                    
                    // Ending building field
                    buildingTextField(
                        text: $finalBuilding,
                        placeholder: "Enter ending building name",
                        isFocused: $isFinalBuildingFocused
                    )
                }
                .padding(.horizontal, 40)
                
                // Find Path button
                Button(action: findPath) {
                    UIConstants.standardButton(text: "Find Path")
                }
                .buttonStyle(PlainButtonStyle())
                
                // Path visualization with animations
                if let path = path, let walkTimes = walkTimes, let totalCost = totalCost, showResults {
                    pathVisualization(path: path, walkTimes: walkTimes, totalCost: totalCost)
                }
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .scrollContentBackground(.hidden)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(UIConstants.uwRed)
                    .font(.system(size: UIConstants.smallTextSize, weight: .semibold))
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    /// Creates a custom text field for building input with placeholder text.
    /// Provides consistent styling and focus management.
    private func buildingTextField(text: Binding<String>, placeholder: String, isFocused: FocusState<Bool>.Binding) -> some View {
        ZStack(alignment: .leading) {
            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.gray.opacity(0.7))
                    .padding(.horizontal, 16)
            }
            TextField("", text: text)
                .font(.system(size: UIConstants.smallTextSize))
                .foregroundColor(.black)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .tint(UIConstants.uwRed)
                .focused(isFocused)
        }
        .font(.system(size: UIConstants.smallTextSize))
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(UIConstants.uwRed, lineWidth: 2)
                )
        )
    }
    
    /// Creates an animated visualization of the path with buildings, arrows, and times.
    /// Shows:
    /// - Each building in a bordered box
    /// - Arrows between buildings
    /// - Walking time for each segment
    /// - Total walking time at the bottom
    private func pathVisualization(path: [String], walkTimes: [Double], totalCost: Double) -> some View {
        VStack(spacing: 15) {
            ForEach(0..<path.count, id: \.self) { index in
                // Building name in bordered box
                Text(path[index])
                    .font(.system(size: UIConstants.smallTextSize))
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(UIConstants.uwRed, lineWidth: 1)
                            )
                    )
                    .opacity(animatingIndex >= index ? 1 : 0)
                    .offset(y: animatingIndex >= index ? 0 : 20)
                
                // Arrow and time for all but last building
                if index < path.count - 1 {
                    VStack(spacing: 5) {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(UIConstants.uwRed)
                        Text(String(format: "%.1f seconds", walkTimes[index]))
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                    .opacity(animatingIndex > index ? 1 : 0)
                    .offset(y: animatingIndex > index ? 0 : 20)
                }
            }
            
            // Total time at bottom
            Text("It will take you \(String(format: "%.1f", totalCost)) seconds to get from \(path.first ?? "") to \(path.last ?? "")")
                .font(.system(size: UIConstants.smallTextSize))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .opacity(animatingIndex >= path.count - 1 ? 1 : 0)
                .offset(y: animatingIndex >= path.count - 1 ? 0 : 20)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
    }
    
    /// Handles the path finding logic and animations:
    /// - Dismisses keyboard
    /// - Validates input
    /// - Gets shortest path from view model
    /// - Triggers sequential animations for results
    private func findPath() {
        isInitialBuildingFocused = false
        isFinalBuildingFocused = false
        
        withAnimation {
            showResults = false
            animatingIndex = -1
        }
        
        let start = initialBuilding.trimmingCharacters(in: .whitespacesAndNewlines)
        let end = finalBuilding.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if start.isEmpty || end.isEmpty {
            alertMessage = "Please enter both buildings."
            showAlert = true
            return
        }
        
        do {
            if let result = try viewModel.getShortestPath(from: start, to: end) {
                path = result.getPath()
                walkTimes = result.getWalkTimes()
                totalCost = result.getTotalPathCost()
                
                // Start animations
                withAnimation(.easeOut(duration: 0.5)) {
                    showResults = true
                }
                
                // Animate each element sequentially
                for index in 0...(result.getPath().count - 1) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            animatingIndex = index
                        }
                    }
                }
            } else {
                alertMessage = "Invalid destinations or no path found. Please try again."
                showAlert = true
            }
        } catch {
            alertMessage = "Error finding shortest path: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
