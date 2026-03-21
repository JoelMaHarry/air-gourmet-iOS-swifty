import SwiftUI

extension View {
    func agPrimaryButton() -> some View {
        self
            .font(.agButton)
            .foregroundColor(.agWhite)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.agCoral)
            .cornerRadius(AGRadius.button)
    }

    func agSecondaryButton() -> some View {
        self
            .font(.agButton)
            .foregroundColor(.agBlack)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.agWhite)
            .cornerRadius(AGRadius.button)
            .overlay(RoundedRectangle(cornerRadius: AGRadius.button).stroke(Color.agLightGrey, lineWidth: 1))
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Async Image with placeholder
struct AGAsyncImage: View {
    let urlString: String?
    var contentMode: ContentMode = .fill

    var body: some View {
        if let urlString = urlString, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: contentMode)
                case .failure:
                    placeholderView
                case .empty:
                    placeholderView
                @unknown default:
                    placeholderView
                }
            }
        } else {
            placeholderView
        }
    }

    private var placeholderView: some View {
        Rectangle()
            .fill(Color.agOffWhite)
            .overlay(Image(systemName: "fork.knife").foregroundColor(Color.agMediumGrey).font(.system(size: 32)))
    }
}
