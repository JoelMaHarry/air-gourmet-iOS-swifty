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

// MARK: - Color hex initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a,r,g,b) = (255,(int>>8)*17,(int>>4 & 0xF)*17,(int & 0xF)*17)
        case 6:  (a,r,g,b) = (255,int>>16,int>>8 & 0xFF,int & 0xFF)
        case 8:  (a,r,g,b) = (int>>24,int>>16 & 0xFF,int>>8 & 0xFF,int & 0xFF)
        default: (a,r,g,b) = (255,0,0,0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
