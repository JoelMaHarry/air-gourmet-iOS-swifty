import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authStore: AuthStore
    @State private var showEditProfile = false
    @State private var showOrderHistory = false
    @State private var showDeleteConfirm = false

    var body: some View {
        ScrollView {
            VStack(spacing: AGSpacing.xl) {
                Text("PROFILE")
                    .font(.agSectionTitle)
                    .foregroundColor(.agBlack)
                    .kerning(1.5)
                    .padding(.top, AGSpacing.xl)

                if let user = authStore.currentUser {
                    // User info
                    VStack(spacing: AGSpacing.md) {
                        Circle()
                            .fill(Color.agOffWhite)
                            .frame(width: 80, height: 80)
                            .overlay(Text(user.fullName.prefix(1)).font(.outfitLight(32)).foregroundColor(.agBlack))

                        Text(user.fullName)
                            .font(.agSectionTitle)
                            .foregroundColor(.agBlack)

                        Text(user.email)
                            .font(.agBody)
                            .foregroundColor(.agDarkGrey)

                        if let company = user.companyName {
                            Text(company)
                                .font(.agBody)
                                .foregroundColor(.agDarkGrey)
                        }
                    }

                    // Actions
                    VStack(spacing: AGSpacing.md) {
                        Button(action: { showEditProfile = true }) {
                            Text("EDIT PROFILE").agSecondaryButton()
                        }

                        Button(action: { showOrderHistory = true }) {
                            Text("ORDER HISTORY").agSecondaryButton()
                        }

                        Button(action: { authStore.logout() }) {
                            Text("SIGN OUT").agSecondaryButton()
                        }

                        Button(action: { showDeleteConfirm = true }) {
                            Text("DELETE ACCOUNT")
                                .font(.agButton)
                                .foregroundColor(.red)
                                .kerning(1)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        }
                    }
                    .padding(.horizontal, AGSpacing.lg)

                } else {
                    // Not logged in
                    VStack(spacing: AGSpacing.md) {
                        Text("Sign in to view your profile and order history.")
                            .font(.agBody)
                            .foregroundColor(.agDarkGrey)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AGSpacing.lg)

                        Button(action: {}) {
                            Text("SIGN IN").agPrimaryButton()
                        }
                        .padding(.horizontal, AGSpacing.lg)
                    }
                }
            }
        }
        .sheet(isPresented: $showEditProfile) {
            if let user = authStore.currentUser {
                EditProfileView(user: user)
            }
        }
        .sheet(isPresented: $showOrderHistory) {
            OrderHistoryView()
        }
        .alert("Delete Account", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                authStore.logout()
            }
        } message: {
            Text("Are you sure you want to delete your account? This cannot be undone.")
        }
    }
}

struct EditProfileView: View {
    let user: User
    @Environment(\.presentationMode) var presentationMode
    @State private var fullName: String
    @State private var email: String
    @State private var phone: String
    @State private var company: String

    init(user: User) {
        self.user = user
        _fullName = State(initialValue: user.fullName)
        _email = State(initialValue: user.email)
        _phone = State(initialValue: user.phoneNumber ?? "")
        _company = State(initialValue: user.companyName ?? "")
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.agBlack)
                        .frame(width: 44, height: 44)
                }
                Spacer()
                Text("EDIT PROFILE")
                    .font(.agPageTitle)
                    .foregroundColor(.agBlack)
                    .kerning(1.5)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, AGSpacing.md)
            .overlay(Rectangle().frame(height: 1).foregroundColor(Color.agLightGrey), alignment: .bottom)

            ScrollView {
                VStack(spacing: AGSpacing.md) {
                    AGTextField(placeholder: "Full Name", text: $fullName)
                    AGTextField(placeholder: "Email", text: $email)
                    AGTextField(placeholder: "Phone", text: $phone)
                    AGTextField(placeholder: "Company", text: $company)

                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("SAVE CHANGES").agPrimaryButton()
                    }
                    .padding(.bottom, AGSpacing.xxxl)
                }
                .padding(.horizontal, AGSpacing.lg)
                .padding(.top, AGSpacing.lg)
            }
        }
        .background(Color.agWhite)
    }
}
