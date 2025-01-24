import SwiftUI

/// The MainView serves as the main interface for UW Path Finder.
/// It presents three main options to users:
/// 1. Load File: Allows loading of the campus.dot file
/// 2. Show Data Stats: Displays statistics about the loaded data
/// 3. Find Shortest Path: Finds the shortest path between two locations
///
/// Navigation:
/// - Uses NavigationStack for hierarchical navigation
/// - Shows alerts if actions are attempted before loading data
/// - Manages state for different views and navigation
struct MainView: View {
    @StateObject private var viewModel = PathFinderViewModel(graph: DijkstraGraph<String, Double>())
    
    @State private var showStatsView = false
    @State private var showPathFinderView = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    UIConstants.headerText("Welcome to UW Path Finder!")
                    UIConstants.subheaderText("Please Select an Option Below!")
                        .padding(.bottom, 20)
                    
                    VStack(spacing: 30) {
                        NavigationLink(destination: LoadFileView(viewModel: viewModel)) {
                            UIConstants.standardButton(text: "Load File")
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            if !viewModel.isFileLoaded {
                                alertMessage = "Please load a file first"
                                showAlert = true
                            } else {
                                showStatsView = true
                            }
                        }) {
                            UIConstants.standardButton(text: "Show Data Stats")
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            if !viewModel.isFileLoaded {
                                alertMessage = "Please load a file first"
                                showAlert = true
                            } else {
                                showPathFinderView = true
                            }
                        }) {
                            UIConstants.standardButton(text: "Find Shortest Path")
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .scrollContentBackground(.hidden)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationDestination(isPresented: $showStatsView) {
                StatsView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $showPathFinderView) {
                PathFinderView(viewModel: viewModel)
            }
        }
    }
}
