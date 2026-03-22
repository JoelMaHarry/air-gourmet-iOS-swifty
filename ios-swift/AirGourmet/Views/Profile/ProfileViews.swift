import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var orderStore: OrderStore
    @State private var showEditProfile = false
    @State private var showOrderHistory = false
    @State private var showDeleteConfirm = false
    @State private var showAuth = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Text("PROFILE")
                    .font(.outfitLight(18))
                    .foregroundColor(.agBlack)
                    .kerning(1.5)
                    .padding(.top, AGSpacing.xl)
                    .padding(.bottom, AGSpacing.xl)

                if let user = authStore.currentUser {
                    loggedInView(user: user)
                } else {
                    loggedOutView
                }

                StandardFooter()
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
        .sheet(isPresented: $showAuth) {
            AuthView()
        }
        .alert("Delete Account", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) { authStore.logout() }
        } message: {
            Text("Are you sure you want to delete your account? This cannot be undone.")
        }
    }

    private func loggedInView(user: User) -> some View {
        VStack(spacing: 0) {
            // Profile fields
            VStack(spacing: 0) {
                profileField("YOUR NAME", value: user.fullName)
                profileField("YOUR USERNAME", value: user.username)
                profileField("YOUR EMAIL", value: user.email)
                profileField("YOUR COMPANY", value: user.companyName ?? "—")
                profileField("YOUR PHONE (OPTIONAL)", value: user.phoneNumber ?? "—")
            }
            .padding(.horizontal, AGSpacing.lg)

            Divider()
                .padding(.vertical, AGSpacing.lg)

            // Action buttons grid
            VStack(spacing: AGSpacing.md) {
                HStack(spacing: AGSpacing.md) {
                    actionButton("EDIT PROFILE") { showEditProfile = true }
                    actionButton("CHANGE PASSWORD") {}
                }
                HStack(spacing: AGSpacing.md) {
                    actionButton("LOG OUT") { authStore.logout() }
                    actionButton("DELETE ACCOUNT") { showDeleteConfirm = true }
                }
            }
            .padding(.horizontal, AGSpacing.lg)

            Divider()
                .padding(.vertical, AGSpacing.lg)

            // Account Summary
            VStack(spacing: AGSpacing.md) {
                Text("ACCOUNT SUMMARY")
                    .font(.outfitLight(12))
                    .foregroundColor(.agDarkGrey)
                    .kerning(1)

                HStack(spacing: AGSpacing.md) {
                    summaryCard(value: "\(orderStore.orders.count)", label: "Total Orders")
                    summaryCard(value: "CLIENT", label: "ACCOUNT TYPE")
                }
            }
            .padding(.horizontal, AGSpacing.lg)

            // Order History button
            Button(action: { showOrderHistory = true }) {
                Text("ORDER HISTORY")
                    .font(.outfitLight(14))
                    .foregroundColor(.agWhite)
                    .kerning(1)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.agCoral)
                    .cornerRadius(8)
            }
            .padding(.horizontal, AGSpacing.lg)
            .padding(.top, AGSpacing.lg)
            .padding(.bottom, AGSpacing.xl)
        }
    }

    private var loggedOutView: some View {
        VStack(spacing: AGSpacing.lg) {
            Image("ag-logo-black")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text("Sign in to view your profile and order history.")
                .font(.agBody)
                .foregroundColor(.agDarkGrey)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AGSpacing.lg)

            Button(action: { showAuth = true }) {
                Text("SIGN IN")
                    .font(.outfitLight(14))
                    .foregroundColor(.agWhite)
                    .kerning(1)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.agCoral)
                    .cornerRadius(8)
            }
            .padding(.horizontal, AGSpacing.lg)
            .padding(.bottom, AGSpacing.xl)
        }
    }

    private func profileField(_ label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.outfitLight(11))
                .foregroundColor(.agDarkGrey)
                .kerning(1)
            Text(value)
                .font(.agBody)
                .foregroundColor(.agBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AGSpacing.md)
                .background(Color(red: 1.0, green: 0.95, blue: 0.95))
                .cornerRadius(8)
        }
        .padding(.bottom, AGSpacing.md)
    }

    private func actionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.outfitLight(12))
                .foregroundColor(.agDarkGrey)
                .kerning(0.8)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                .cornerRadius(8)
        }
    }

    private func summaryCard(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.outfitLight(22))
                .foregroundColor(.agCoral)
            Text(label)
                .font(.outfitLight(11))
                .foregroundColor(.agDarkGrey)
                .kerning(0.8)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(Color(red: 0.93, green: 0.93, blue: 0.93))
        .cornerRadius(8)
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
                VStack(alignment: .leading, spacing: AGSpacing.md) {
                    AGTextField(placeholder: "Full Name", text: $fullName)
                    AGTextField(placeholder: "Email", text: $email)
                    AGTextField(placeholder: "Phone", text: $phone)
                    AGTextField(placeholder: "Company", text: $company)

                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("SAVE CHANGES")
                            .font(.outfitLight(14))
                            .foregroundColor(.agWhite)
                            .kerning(1)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.agCoral)
                            .cornerRadius(8)
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
