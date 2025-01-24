import SwiftUI

/// Shows statistics about the loaded campus data including:
/// - Number of buildings (nodes) in the graph
/// - Number of paths (edges) between buildings
/// - Total walking time across all paths
///
/// The data is displayed in a card-like view with dividers between stats.
struct StatsView: View {
    /// View model for accessing campus data statistics
    @ObservedObject var viewModel: PathFinderViewModel<DijkstraGraph<String, Double>>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                UIConstants.headerText("Campus Data Stats")
                
                // Stats display in a card-like view
                VStack(alignment: .leading, spacing: 20) {
                    let stats = viewModel.getDatasetStats().split(separator: "\n")
                    ForEach(stats, id: \.self) { stat in
                        HStack {
                            Text(String(stat))
                                .font(.system(size: UIConstants.mediumTextSize))
                                .foregroundColor(.gray)
                        }
                        if stat != stats.last {
                            Divider()
                                .background(UIConstants.uwRed.opacity(0.3))
                        }
                    }
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(UIConstants.uwRed.opacity(0.3), lineWidth: 2)
                        )
                )
                .padding(.horizontal, 20)
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
            .frame(maxWidth: .infinity)
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
    }
}
