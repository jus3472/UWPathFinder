import SwiftUI

/// The LoadFileView allows the user to input the file name (which must be "campus.dot").
/// If the file name is correct, the ViewModel's readDataFromFile is called and file data is loaded.
/// Otherwise, an error is displayed.
///
/// Features:
/// - Custom styled text input field with placeholder
/// - Success/error alerts with appropriate messages
/// - Automatic navigation back to main view on successful load
/// - Back button in navigation bar
struct LoadFileView: View {
    @ObservedObject var viewModel: PathFinderViewModel<DijkstraGraph<String, Double>>
    @Environment(\.dismiss) private var dismiss
    
    @State private var fileName: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                UIConstants.headerText("Load Data File")
                UIConstants.subheaderText("Enter the dot file name")
                
                // Custom styled text field
                ZStack(alignment: .leading) {
                    if fileName.isEmpty {
                        Text("e.g. campus.dot")
                            .font(.system(size: UIConstants.smallTextSize))
                            .foregroundColor(Color.gray.opacity(0.7))
                            .padding(.horizontal, 16)
                    }
                    TextField("", text: $fileName)
                        .font(.system(size: UIConstants.smallTextSize))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .tint(UIConstants.uwRed)
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(UIConstants.uwRed, lineWidth: 2)
                        )
                )
                .padding(.horizontal, 40)
                
                Button(action: loadFile) {
                    UIConstants.standardButton(text: "Load File")
                }
                .buttonStyle(PlainButtonStyle())
                
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(isSuccess ? "Success" : "Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if isSuccess {
                        dismiss()
                    }
                }
            )
        }
    }
    
    private func loadFile() {
        if fileName.trimmingCharacters(in: .whitespacesAndNewlines) != "campus.dot" {
            alertMessage = "File not found. Please type exactly 'campus.dot'."
            isSuccess = false
            showAlert = true
        } else {
            do {
                try viewModel.readDataFromFile(filePath: fileName)
                alertMessage = "Successfully loaded \(fileName)!"
                isSuccess = true
                showAlert = true
            } catch {
                alertMessage = "Error loading file: \(error.localizedDescription)"
                isSuccess = false
                showAlert = true
            }
        }
    }
}
