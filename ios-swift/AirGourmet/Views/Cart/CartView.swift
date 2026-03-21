import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartStore: CartStore
    @EnvironmentObject var authStore: AuthStore
    @Environment(\.presentationMode) var presentationMode
    @State private var showDeliveryDetails = false
    @State private var showAuth = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Spacer()
                Text("YOUR ORDER")
                    .font(.agPageTitle)
                    .foregroundColor(.agBlack)
                    .kerning(1.5)
                Spacer()
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.agBlack)
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, AGSpacing.md)
            .overlay(Rectangle().frame(height: 1).foregroundColor(Color.agLightGrey), alignment: .bottom)

            if cartStore.isEmpty {
                Spacer()
                Text("Your cart is empty")
                    .font(.agBody)
                    .foregroundColor(.agMediumGrey)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(cartStore.items) { item in
                            CartItemRow(item: item)
                            Divider()
                        }
                    }
                }

                // Footer
                VStack(spacing: AGSpacing.md) {
                    Divider()

                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("CONTINUE SHOPPING")
                            .agSecondaryButton()
                    }
                    .padding(.horizontal, AGSpacing.lg)

                    Button(action: {
                        if authStore.isLoggedIn {
                            showDeliveryDetails = true
                        } else {
                            showAuth = true
                        }
                    }) {
                        Text("TO DELIVERY DETAILS")
                            .agPrimaryButton()
                    }
                    .padding(.horizontal, AGSpacing.lg)
                    .padding(.bottom, AGSpacing.lg)
                }
            }
        }
        .background(Color.agWhite)
        .sheet(isPresented: $showDeliveryDetails) {
            DeliveryDetailsView()
        }
        .sheet(isPresented: $showAuth) {
            AuthView()
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    @EnvironmentObject var cartStore: CartStore

    var body: some View {
        HStack(spacing: AGSpacing.md) {
            AGAsyncImage(urlString: item.menuItem.imageUrl)
                .frame(width: 70, height: 70)
                .cornerRadius(AGRadius.card)

            VStack(alignment: .leading, spacing: AGSpacing.xs) {
                Text(item.menuItem.name)
                    .font(.agMenuItemTitle)
                    .foregroundColor(.agBlack)

                if let instructions = item.specialInstructions, !instructions.isEmpty {
                    Text(instructions)
                        .font(.agMenuItemDescription)
                        .foregroundColor(.agMediumGrey)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Quantity controls
            HStack(spacing: 0) {
                Button(action: { cartStore.updateQuantity(item, quantity: item.quantity - 1) }) {
                    Image(systemName: "minus")
                        .foregroundColor(.agBlack)
                        .frame(width: 36, height: 36)
                }
                Text("\(item.quantity)")
                    .font(.agMenuItemTitle)
                    .foregroundColor(.agBlack)
                    .frame(width: 30)
                Button(action: { cartStore.updateQuantity(item, quantity: item.quantity + 1) }) {
                    Image(systemName: "plus")
                        .foregroundColor(.agBlack)
                        .frame(width: 36, height: 36)
                }
            }
            .overlay(RoundedRectangle(cornerRadius: AGRadius.input).stroke(Color.agLightGrey, lineWidth: 1))
        }
        .padding(AGSpacing.lg)
    }
}
