import SwiftUI

// MARK: - Auth Container

struct AuthView: View {
    @State private var mode: AuthMode = .signIn
    @Environment(\.presentationMode) var presentationMode

    enum AuthMode { case signIn, signUp, forgotPassword }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Logo — 200x200, centered, top padding 76px
                Image("ag-logo-black")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 76)

                // Title
                VStack(spacing: 2) {
                    Text("AIR GOURMET")
                        .font(.outfitLight(18))
                        .foregroundColor(.agBlack)
                        .kerning(0.9)
                    Text("THE FINEST DINING IN THE AIR")
                        .font(.outfitLight(18))
                        .foregroundColor(.agBlack)
                        .kerning(0.9)
                }
                .multilineTextAlignment(.center)
                .padding(.top, 16)

                // Toggle — SIGN IN / REGISTER
                HStack(spacing: 12) {
                    authToggleButton("SIGN IN", isActive: mode == .signIn) {
                        mode = .signIn
                    }
                    authToggleButton("REGISTER", isActive: mode == .signUp) {
                        mode = .signUp
                    }
                }
                .padding(.horizontal, 60)
                .padding(.top, 32)
                .padding(.bottom, 24)

                // Content
                switch mode {
                case .signIn:
                    SignInFormView(
                        onForgotPassword: { mode = .forgotPassword },
                        onSuccess: { presentationMode.wrappedValue.dismiss() }
                    )
                case .signUp:
                    SignUpFormView(
                        onSuccess: { presentationMode.wrappedValue.dismiss() }
                    )
                case .forgotPassword:
                    ForgotPasswordView(onBack: { mode = .signIn })
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color.agWhite)
    }

    private func authToggleButton(_ title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.outfitLight(14))
                .foregroundColor(isActive ? Color.white : Color(hex: "#6B6B6B"))
                .kerning(0.7)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(isActive ? Color(hex: "#888888") : Color(hex: "#EBEBEB"))
                .cornerRadius(6)
        }
    }
}

// MARK: - Sign In Form

struct SignInFormView: View {
    @EnvironmentObject var authStore: AuthStore
    @State private var username = ""
    @State private var password = ""
    @State private var rememberMe = false
    var onForgotPassword: () -> Void
    var onSuccess: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // USERNAME field
            AGFormField(label: "USERNAME", placeholder: "Enter your username", text: $username)
                .padding(.bottom, 14)

            // PASSWORD field
            AGFormField(label: "PASSWORD", placeholder: "••••••••", text: $password, isSecure: true)
                .padding(.bottom, 16)

            // Remember Me
            HStack(spacing: 8) {
                Button(action: { rememberMe.toggle() }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color(hex: "#AAAAAA"), lineWidth: 1)
                            .frame(width: 18, height: 16)
                        if rememberMe {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.agBlack)
                        }
                    }
                }
                Text("Remember Me")
                    .font(.outfitLight(11))
                    .foregroundColor(Color(hex: "#6B6B6B"))
                    .kerning(1.1)
            }
            .padding(.bottom, 32)

            if let error = authStore.errorMessage {
                Text(error)
                    .font(.hanumanMedium(14))
                    .foregroundColor(.red)
                    .padding(.bottom, 12)
            }

            // SIGN IN button — coral
            Button(action: {
                Task {
                    await authStore.login(username: username, password: password)
                    if authStore.isLoggedIn { onSuccess() }
                }
            }) {
                Group {
                    if authStore.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("SIGN IN")
                            .font(.outfitLight(14))
                            .foregroundColor(.white)
                            .kerning(0.7)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(Color.agCoral)
                .cornerRadius(6)
            }
            .padding(.bottom, 12)

            // FORGOT PASSWORD button — light grey
            Button(action: onForgotPassword) {
                Text("FORGOT PASSWORD")
                    .font(.outfitLight(14))
                    .foregroundColor(Color(hex: "#6B6B6B"))
                    .kerning(0.7)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color(hex: "#EBEBEB"))
                    .cornerRadius(6)
            }
            .padding(.bottom, 24)

            // Trouble logging in
            HStack(spacing: 4) {
                Text("Trouble logging in?")
                    .font(.hanumanMedium(14))
                    .foregroundColor(Color(hex: "#6B6B6B"))
                Button(action: {}) {
                    Text("Contact us.")
                        .font(.hanumanMedium(14))
                        .foregroundColor(Color(hex: "#6B6B6B"))
                        .underline()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 60)
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Sign Up Form

struct SignUpFormView: View {
    @EnvironmentObject var authStore: AuthStore
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    @State private var companyName = ""
    @State private var email = ""
    @State private var phone = ""
    var onSuccess: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // USERNAME *
            AGFormField(label: "USERNAME", placeholder: "Enter your username", text: $username, required: true)
                .padding(.bottom, 14)

            // PASSWORD + CONFIRM PASSWORD side by side
            HStack(spacing: 12) {
                AGFormField(label: "PASSWORD", placeholder: "•••••••", text: $password, isSecure: true)
                AGFormField(label: "CONFIRM PASSWORD", placeholder: "•••••••", text: $confirmPassword, isSecure: true)
            }
            .padding(.bottom, 14)

            // FULL NAME *
            AGFormField(label: "FULL NAME", placeholder: "Your Full Name", text: $fullName, required: true)
                .padding(.bottom, 14)

            // COMPANY NAME
            AGFormField(label: "COMPANY NAME", placeholder: "Your Company", text: $companyName)
                .padding(.bottom, 14)

            // EMAIL *
            AGFormField(label: "EMAIL", placeholder: "your@email.com", text: $email, required: true)
                .padding(.bottom, 14)

            // PHONE (OPTIONAL)
            AGFormField(label: "PHONE (OPTIONAL)", placeholder: "Your phone Number", text: $phone)
                .padding(.bottom, 32)

            if let error = authStore.errorMessage {
                Text(error)
                    .font(.hanumanMedium(14))
                    .foregroundColor(.red)
                    .padding(.bottom, 12)
            }

            // CREATE ACCOUNT button — coral, centered
            HStack {
                Spacer()
                Button(action: {
                    Task {
                        let request = RegisterRequest(
                            username: username,
                            password: password,
                            fullName: fullName,
                            email: email,
                            phoneNumber: phone.isEmpty ? nil : phone,
                            companyName: companyName.isEmpty ? nil : companyName
                        )
                        await authStore.register(request: request)
                        if authStore.isLoggedIn { onSuccess() }
                    }
                }) {
                    Group {
                        if authStore.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("CREATE ACCOUNT")
                                .font(.outfitLight(14))
                                .foregroundColor(.white)
                                .kerning(0.7)
                        }
                    }
                    .frame(width: 176, height: 40)
                    .background(Color.agCoral)
                    .cornerRadius(6)
                }
                Spacer()
            }
            .padding(.bottom, 60)
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Forgot Password

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var submitted = false
    var onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if submitted {
                Text("If an account exists for \(email), you will receive a password reset email shortly.")
                    .font(.hanumanMedium(16))
                    .foregroundColor(Color(hex: "#6B6B6B"))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
            } else {
                AGFormField(label: "EMAIL", placeholder: "your@email.com", text: $email)
                    .padding(.bottom, 24)

                HStack {
                    Spacer()
                    Button(action: { submitted = true }) {
                        Text("SEND RESET LINK")
                            .font(.outfitLight(14))
                            .foregroundColor(.white)
                            .kerning(0.7)
                            .frame(width: 176, height: 40)
                            .background(Color.agCoral)
                            .cornerRadius(6)
                    }
                    Spacer()
                }
                .padding(.bottom, 24)
            }

            HStack {
                Spacer()
                Button(action: onBack) {
                    Text("Back to Sign In")
                        .font(.hanumanMedium(14))
                        .foregroundColor(Color(hex: "#6B6B6B"))
                        .underline()
                }
                Spacer()
            }
            .padding(.bottom, 60)
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - AGFormField (from Figma specs)
// Label: Outfit Light 11px, #6B6B6B, tracking 1.1px, uppercase
// Input: white bg, 1px border #AAAAAA, rounded 6px, height 40px, 13px horizontal padding
// Placeholder: Hanuman Regular 14px, #AAAAAA

struct AGFormField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var required: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Label
            HStack(spacing: 2) {
                Text(label)
                    .font(.outfitLight(11))
                    .foregroundColor(Color(hex: "#6B6B6B"))
                    .kerning(1.1)
                if required {
                    Text("*")
                        .font(.outfitLight(11))
                        .foregroundColor(Color.agCoral)
                }
            }

            // Input
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(Font.custom("Hanuman-Medium", size: 14))
            .foregroundColor(.agBlack)
            .accentColor(.agCoral)
            .padding(.horizontal, 13)
            .padding(.vertical, 9)
            .frame(height: 40)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(text.isEmpty ? Color(hex: "#AAAAAA") : Color.agCoral, lineWidth: 1)
            )
        }
    }
}

// MARK: - AGTextField (kept for backward compatibility)
struct AGTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        AGFormField(label: "", placeholder: placeholder, text: $text, isSecure: isSecure)
    }
}

// MARK: - Corner Radius Helper
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Hex Color Helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
