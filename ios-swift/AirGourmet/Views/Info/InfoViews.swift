import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cartStore: CartStore
    @State private var isSideNavOpen = false
    @State private var isCartOpen = false

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                AGNavigationHeader(
                    title: "ABOUT",
                    onMenuTap: { withAnimation { isSideNavOpen = true } },
                    cartCount: cartStore.itemCount,
                    onCartTap: { isCartOpen = true },
                    showBackButton: true,
                    onBackTap: { presentationMode.wrappedValue.dismiss() }
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: AGSpacing.xl) {
                        Text("30 YEARS OF TAKING CATERING HIGHER")
                            .font(.agSectionTitle)
                            .foregroundColor(.agBlack)
                            .kerning(1)
                            .padding(.top, AGSpacing.xl)

                        Text("We've been dedicated to helping aviation pros like you for 36 years. Our focus is straightforward: give clients the best food in the air. We live to talk catering and supporting our clients in the air.")
                            .font(.agBody)
                            .foregroundColor(.agBlack)
                            .lineSpacing(6)

                        Divider()

                        Text("CONCIERGE SERVICES")
                            .font(.agSectionTitle)
                            .foregroundColor(.agBlack)
                            .kerning(1)

                        Text("We provide the accoutrements that soften the rigors of flying — simple things like ergonomic back covers for the duration of your sojourn. We can provide you with everything from copiers, videos, Xbox service, office supplies, gifts, personal shopping, concierges, transportation services — whatever your special needs might be.")
                            .font(.agBody)
                            .foregroundColor(.agBlack)
                            .lineSpacing(6)

                        StandardFooter()
                    }
                    .padding(.horizontal, AGSpacing.lg)
                }
            }

            SideNavigationView(isOpen: $isSideNavOpen)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isCartOpen) { CartView() }
    }
}

struct ContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cartStore: CartStore
    @State private var isSideNavOpen = false
    @State private var isCartOpen = false
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var submitted = false

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                AGNavigationHeader(
                    title: "CONTACT US",
                    onMenuTap: { withAnimation { isSideNavOpen = true } },
                    cartCount: cartStore.itemCount,
                    onCartTap: { isCartOpen = true },
                    showBackButton: true,
                    onBackTap: { presentationMode.wrappedValue.dismiss() }
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: AGSpacing.xl) {
                        Text("GET IN TOUCH")
                            .font(.agSectionTitle)
                            .foregroundColor(.agBlack)
                            .kerning(1)
                            .padding(.top, AGSpacing.xl)

                        // Phone numbers
                        VStack(alignment: .leading, spacing: AGSpacing.md) {
                            contactRow(label: "LOS ANGELES", value: "702.457.0500 | 702.459.0589")
                            contactRow(label: "LAS VEGAS", value: "702.457.0500 | 702.459.0589")
                            contactRow(label: "NATIONWIDE", value: "800.222.2466 | 602.275.4601")
                        }

                        Divider()

                        if submitted {
                            VStack(spacing: AGSpacing.md) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(.agCoral)
                                Text("Message sent! We'll be in touch shortly.")
                                    .font(.agBody)
                                    .foregroundColor(.agDarkGrey)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AGSpacing.xl)
                        } else {
                            VStack(spacing: AGSpacing.md) {
                                AGTextField(placeholder: "Your Name", text: $name)
                                AGTextField(placeholder: "Your Email", text: $email)

                                VStack(alignment: .leading, spacing: AGSpacing.xs) {
                                    Text("MESSAGE")
                                        .font(.agButton)
                                        .foregroundColor(.agDarkGrey)
                                        .kerning(1)
                                    TextEditor(text: $message)
                                        .font(.agBody)
                                        .frame(height: 120)
                                        .padding(AGSpacing.md)
                                        .background(Color.agOffWhite)
                                        .cornerRadius(AGRadius.input)
                                }

                                Button(action: { submitted = true }) {
                                    Text("SEND MESSAGE").agPrimaryButton()
                                }
                            }
                        }

                        StandardFooter()
                    }
                    .padding(.horizontal, AGSpacing.lg)
                }
            }

            SideNavigationView(isOpen: $isSideNavOpen)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isCartOpen) { CartView() }
    }

    private func contactRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.agButton)
                .foregroundColor(.agDarkGrey)
                .kerning(1)
            Text(value)
                .font(.agBody)
                .foregroundColor(.agBlack)
        }
    }
}
