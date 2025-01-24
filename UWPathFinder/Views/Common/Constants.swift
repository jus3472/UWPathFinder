import SwiftUI

/// Constants and reusable UI components used throughout the app.
/// This helps maintain consistency in styling and reduces code duplication.
enum UIConstants {
    /// Official UW-Madison red color
    static let uwRed = Color(red: 197/255, green: 5/255, blue: 12/255)
    
    /// Standard button dimensions
    static let standardButtonWidth: CGFloat = 280
    static let standardButtonHeight: CGFloat = 60
    
    /// Text sizes used throughout the app
    static let largeTextSize: CGFloat = 38  // Used for main headers
    static let mediumTextSize: CGFloat = 24 // Used for subheaders and buttons
    static let smallTextSize: CGFloat = 20  // Used for body text and input fields
    
    /// Creates a standardized button with consistent styling across the app
    static func standardButton(text: String) -> some View {
        Text(text)
            .frame(width: standardButtonWidth, height: standardButtonHeight)
            .font(.system(size: mediumTextSize, weight: .semibold))
            .foregroundColor(.white)
            .background(uwRed)
            .cornerRadius(12)
            .shadow(radius: 3)
    }
    
    /// Creates a standardized header text with UW colors and proper spacing
    static func headerText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: largeTextSize, weight: .bold))
            .foregroundColor(uwRed)
            .padding(.top, 60)
            .multilineTextAlignment(.center)
    }
    
    /// Creates a standardized subheader text with proper styling and spacing
    static func subheaderText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: mediumTextSize))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
    }
}
