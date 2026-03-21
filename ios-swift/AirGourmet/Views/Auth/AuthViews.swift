import SwiftUI

struct AuthView: View {
    @State private var mode: AuthMode = .signIn
    @Environment(\.presentationMode) var presentationMode

    enum AuthMode { case signIn, signUp, forgotPassword }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Spacer()
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.agBlack)
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

// MARK: - Sign In

struct SignInView: View {
    @EnvironmentObject var authStore: AuthStore
    @State private var username = ""
    @State private var password = ""
    var onForgotPassword: () -> Void
    var onSignUp: () -> Void
    var onSuccess: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: AGSpacing.xl) {
                Text("SIGN IN")
                    .font(.agSectionTitle)
                    .foregroundColor(.agBlack)
                    .kerning(1.5)
                    .padding(.top, AGSpacing.xl)

                VStack(spacing: AGSpacing.md) {
                    AGTextField(placeholder: "Username", text: $username)
                    AGTextField(placeholder: "Password", text: $password, isSecure: true)
                }
                .padding(.horizontal, AGSpacing.lg)

                if let error = authStore.errorMessage {
                    Text(error)
                        .font(.agMenuItemDescription)
                        .foregroundColor(.red)
                        .padding(.horizontal, AGSpacing.lg)
                }

                Button(action: {
                    Task {
                        await authStore.login(username: username, password: password)
                        if authStore.isLoggedIn { onSuccess() }
                    }
                }) {
                    if authStore.isLoading {
                        ProgressView().tint(.agWhite).agPrimaryButton()
                    } else {
                        Text("SIGN IN").agPrimaryButton()
                    }
                }
                .padding(.horizontal, AGSpacing.lg)

                Button(action: onForgotPassword) {
                    Text("Forgot Password?")
                        .font(.agMenuItemDescription)
                        .foregroundColor(.agCoral)
                        .underline()
                }

                HStack {
                    Text("Don't have an account?")
                        .font(.agMenuItemDescription)
                        .foregroundColor(.agDarkGrey)
                    Button(action: onSignUp) {
                        Text("Sign Up")
                            .font(.agMenuItemDescription)
                            .foregroundColor(.agCoral)
                            .underline()
                    }
                }
                .padding(.bottom, AGSpacing.xxxl)
            }
        }
    }
}

// MARK: - Sign Up

struct SignUpView: View {
    @EnvironmentObject var authStore: AuthStore
    @State private var fullName = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var companyName = ""
    @State private var phone = ""
    var onSignIn: () -> Void
    var onSuccess: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: AGSpacing.xl) {
                Text("CREATE ACCOUNT")
                    .font(.agSectionTitle)
                    .foregroundColor(.agBlack)
                    .kerning(1.5)
                    .padding(.top, AGSpacing.xl)

                VStack(spacing: AGSpacing.md) {
                    AGTextField(placeholder: "Full Name", text: $fullName)
                    AGTextField(placeholder: "Email", text: $email)
                    AGTextField(placeholder: "Username", text: $username)
                    AGTextField(placeholder: "Password", text: $password, isSecure: true)
                    AGTextField(placeholder: "Company Name (optional)", text: $companyName)
                    AGTextField(placeholder: "Phone (optional)", text: $phone)
                }
                .padding(.horizontal, AGSpacing.lg)

                if let error = authStore.errorMessage {
                    Text(error)
                        .font(.agMenuItemDescription)
                        .foregroundColor(.red)
                        .padding(.horizontal, AGSpacing.lg)
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
                    if authStore.isLoading {
                        ProgressView().tint(.agWhite).agPrimaryButton()
                    } else {
                        Text("CREATE ACCOUNT").agPrimaryButton()
                    }
                }
                .padding(.horizontal, AGSpacing.lg)

                HStack {
                    Text("Already have an account?")
                        .font(.agMenuItemDescription)
                        .foregroundColor(.agDarkGrey)
                    Button(action: onSignIn) {
                        Text("Sign In")
                            .font(.agMenuItemDescription)
                            .foregroundColor(.agCoral)
                            .underline()
                    }
                }
                .padding(.bottom, AGSpacing.xxxl)
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
        ScrollView {
            VStack(spacing: AGSpacing.xl) {
                Text("FORGOT PASSWORD")
                    .font(.agSectionTitle)
                    .foregroundColor(.agBlack)
                    .kerning(1.5)
                    .padding(.top, AGSpacing.xl)

                if submitted {
                    Text("If an account exists for \(email), you'll receive a password reset email shortly.")
                        .font(.agBody)
                        .foregroundColor(.agDarkGrey)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AGSpacing.lg)
                } else {
                    AGTextField(placeholder: "Email Address", text: $email)
                        .padding(.horizontal, AGSpacing.lg)

                    Button(action: { submitted = true }) {
                        Text("SEND RESET LINK").agPrimaryButton()
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
        .cornerRadius(AGRadius.input)
        .overlay(RoundedRectangle(cornerRadius: AGRadius.input).stroke(Color.agLightGrey, lineWidth: 1))
    }
}
