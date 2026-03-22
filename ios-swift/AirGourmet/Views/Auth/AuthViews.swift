import SwiftUI

// MARK: - Auth Container

struct AuthView: View {
    @State private var mode: AuthMode = .signIn
    @Environment(\.presentationMode) var presentationMode

    enum AuthMode { case signIn, signUp, forgotPassword }

    var body: some View {
        VStack(spacing: 0) {
            // Close button
            HStack {
                Spacer()
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.agBlack)
                        .font(.system(size: 18))
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, AGSpacing.md)

            switch mode {
            case .signIn:
                SignInView(
                    onForgotPassword: { mode = .forgotPassword },
                    onSignUp: { mode = .signUp },
                    onSuccess: { presentationMode.wrappedValue.dismiss() }
                )
            case .signUp:
                SignUpView(
                    onSignIn: { mode = .signIn },
                    onSuccess: { presentationMode.wrappedValue.dismiss() }
                )
            case .forgotPassword:
                ForgotPasswordView(onBack: { mode = .signIn })
            }
        }
        .background(Color.agWhite)
    }
}

// MARK: - Auth Header (shared logo + title)

private struct AuthHeader: View {
    var body: some View {
        VStack(spacing: 12) {
            Image("ag-logo-black")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)

            Text("AIR GOURMET")
                .font(.outfitLight(28))
                .foregroundColor(.agBlack)
                .kerning(1.5)

            Text("THE FINEST DINING IN THE AIR")
                .font(.outfitLight(13))
                .foregroundColor(.agDarkGrey)
                .kerning(1.5)
        }
        .padding(.top, AGSpacing.lg)
        .padding(.bottom, AGSpacing.xl)
    }
}

// MARK: - Sign In / Register Toggle

private struct AuthToggle: View {
    @Binding var mode: AuthView.AuthMode
    var onSignIn: () -> Void
    var onRegister: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: onSignIn) {
                Text("SIGN IN")
                    .font(.outfitLight(14))
                    .kerning(1)
                    .foregroundColor(mode == .signIn ? .agWhite : .agDarkGrey)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(mode == .signIn ? Color(red: 0.4, green: 0.4, blue: 0.4) : Color(red: 0.93, green: 0.93, blue: 0.93))
                    .cornerRadius(8, corners: [.topLeft, .bottomLeft])
            }
            Button(action: onRegister) {
                Text("REGISTER")
                    .font(.outfitLight(14))
                    .kerning(1)
                    .foregroundColor(mode == .signUp ? .agWhite : .agDarkGrey)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(mode == .signUp ? Color(red: 0.4, green: 0.4, blue: 0.4) : Color(red: 0.93, green: 0.93, blue: 0.93))
                    .cornerRadius(8, corners: [.topRight, .bottomRight])
            }
        }
        .padding(.horizontal, AGSpacing.lg)
        .padding(.bottom, AGSpacing.lg)
    }
}

// MARK: - Sign In

struct SignInView: View {
    @EnvironmentObject var authStore: AuthStore
    @State private var username = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var authMode: AuthView.AuthMode = .signIn
    var onForgotPassword: () -> Void
    var onSignUp: () -> Void
    var onSuccess: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                AuthHeader()

                AuthToggle(mode: $authMode, onSignIn: {}, onRegister: onSignUp)

                VStack(alignment: .leading, spacing: AGSpacing.md) {

                    // Username
                    fieldLabel("USERNAME")
                    AGTextField(placeholder: "Enter your username", text: $username)

                    // Password
                    fieldLabel("PASSWORD")
                    AGTextField(placeholder: "••••••••", text: $password, isSecure: true)

                    // Remember me
                    HStack(spacing: AGSpacing.xs) {
                        Button(action: { rememberMe.toggle() }) {
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.agMediumGrey, lineWidth: 1)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    rememberMe ? Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.agBlack) : nil
                                )
                        }
                        Text("REMEMBER ME")
                            .font(.outfitLight(12))
                            .foregroundColor(.agDarkGrey)
                            .kerning(1)
                    }
                    .padding(.top, AGSpacing.xs)

                    if let error = authStore.errorMessage {
                        Text(error)
                            .font(.agMenuItemDescription)
                            .foregroundColor(.red)
                    }

                    // Sign In button
                    Button(action: {
                        Task {
                            await authStore.login(username: username, password: password)
                            if authStore.isLoggedIn { onSuccess() }
                        }
                    }) {
                        Group {
                            if authStore.isLoading {
                                ProgressView().tint(.agWhite)
                            } else {
                                Text("SIGN IN")
                            }
                        }
                        .font(.outfitLight(14))
                        .foregroundColor(.agWhite)
                        .kerning(1)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.agCoral)
                        .cornerRadius(8)
                    }
                    .padding(.top, AGSpacing.md)

                    // Forgot password
                    Button(action: onForgotPassword) {
                        Text("FORGOT PASSWORD")
                            .font(.outfitLight(14))
                            .foregroundColor(.agDarkGrey)
                            .kerning(1)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                            .cornerRadius(8)
                    }

                    // Trouble logging in
                    HStack(spacing: 4) {
                        Text("Trouble logging in?")
                            .font(.hanumanMedium(14))
                            .foregroundColor(.agDarkGrey)
                        Button(action: {}) {
                            Text("Contact us.")
                                .font(.hanumanMedium(14))
                                .foregroundColor(.agDarkGrey)
                                .underline()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, AGSpacing.lg)
                    .padding(.bottom, AGSpacing.xxxl)
                }
                .padding(.horizontal, AGSpacing.lg)
            }
        }
    }

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.outfitLight(12))
            .foregroundColor(.agDarkGrey)
            .kerning(1)
    }
}

// MARK: - Sign Up

struct SignUpView: View {
    @EnvironmentObject var authStore: AuthStore
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    @State private var companyName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var authMode: AuthView.AuthMode = .signUp
    var onSignIn: () -> Void
    var onSuccess: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                AuthHeader()

                AuthToggle(mode: $authMode, onSignIn: onSignIn, onRegister: {})

                VStack(alignment: .leading, spacing: AGSpacing.md) {

                    fieldLabel("USERNAME *")
                    AGTextField(placeholder: "Enter your username", text: $username)

                    // Password row (side by side)
                    HStack(spacing: AGSpacing.md) {
                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("PASSWORD")
                            AGTextField(placeholder: "", text: $password, isSecure: true)
                        }
                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("CONFIRM PASSWORD")
                            AGTextField(placeholder: "••••••••", text: $confirmPassword, isSecure: true)
                        }
                    }

                    fieldLabel("FULL NAME *")
                    AGTextField(placeholder: "Your Full Name", text: $fullName)

                    fieldLabel("COMPANY NAME")
                    AGTextField(placeholder: "Your Company", text: $companyName)

                    fieldLabel("EMAIL *")
                    AGTextField(placeholder: "your@email.com", text: $email)

                    fieldLabel("PHONE (OPTIONAL)")
                    AGTextField(placeholder: "your Phone Number", text: $phone)

                    if let error = authStore.errorMessage {
                        Text(error)
                            .font(.agMenuItemDescription)
                            .foregroundColor(.red)
                    }

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
                                ProgressView().tint(.agWhite)
                            } else {
                                Text("CREATE ACCOUNT")
                            }
                        }
                        .font(.outfitLight(14))
                        .foregroundColor(.agWhite)
                        .kerning(1)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.agCoral)
                        .cornerRadius(8)
                    }
                    .padding(.top, AGSpacing.md)
                    .padding(.bottom, AGSpacing.xxxl)
                }
                .padding(.horizontal, AGSpacing.lg)
            }
        }
    }

    private func fieldLabel(_ text: String) -> some View {
        HStack(spacing: 2) {
            let parts = text.components(separatedBy: " *")
            Text(parts[0])
                .font(.outfitLight(12))
                .foregroundColor(.agDarkGrey)
                .kerning(1)
            if parts.count > 1 {
                Text("*")
                    .font(.outfitLight(12))
                    .foregroundColor(.red)
            }
        }
    }
}

// MARK: - Forgot Password

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var submitted = false
    var onBack: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AGSpacing.xl) {
                AuthHeader()

                Text("FORGOT PASSWORD")
                    .font(.agSectionTitle)
                    .foregroundColor(.agBlack)
                    .kerning(1.5)

                if submitted {
                    Text("If an account exists for \(email), you'll receive a password reset email shortly.")
                        .font(.agBody)
                        .foregroundColor(.agDarkGrey)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AGSpacing.lg)
                } else {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("EMAIL")
                            .font(.outfitLight(12))
                            .foregroundColor(.agDarkGrey)
                            .kerning(1)
                        AGTextField(placeholder: "your@email.com", text: $email)
                    }
                    .padding(.horizontal, AGSpacing.lg)

                    Button(action: { submitted = true }) {
                        Text("SEND RESET LINK")
                            .font(.outfitLight(14))
                            .foregroundColor(.agWhite)
                            .kerning(1)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.agCoral)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, AGSpacing.lg)
                }

                Button(action: onBack) {
                    Text("Back to Sign In")
                        .font(.agMenuItemDescription)
                        .foregroundColor(.agCoral)
                        .underline()
                }
                .padding(.bottom, AGSpacing.xxxl)
            }
        }
    }
}

// MARK: - Shared Text Field

struct AGTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .font(.agBody)
        .padding(AGSpacing.md)
        .frame(height: 50)
        .background(Color.agWhite)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.agLightGrey, lineWidth: 1))
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
