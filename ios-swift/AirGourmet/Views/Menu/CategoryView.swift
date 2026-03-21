import SwiftUI

// MARK: - Category View

struct CategoryView: View {
    let category: MenuCategory
    @EnvironmentObject var menuStore: MenuStore
    @EnvironmentObject var cartStore: CartStore
    @State private var selectedItem: MenuItem?
    @State private var showDishDetail = false
    @State private var isSideNavOpen = false
    @State private var isCartOpen = false
    @Environment(\.presentationMode) var presentationMode

    var items: [MenuItem] {
        menuStore.itemsFor(category: category)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                AGNavigationHeader(
                    title: category.rawValue.uppercased(),
                    onMenuTap: { withAnimation { isSideNavOpen = true } },
                    cartCount: cartStore.itemCount,
                    onCartTap: { isCartOpen = true },
                    showBackButton: true,
                    onBackTap: { presentationMode.wrappedValue.dismiss() }
                )

                if menuStore.isLoading {
                    Spacer()
                    ProgressView().tint(.agCoral)
                    Spacer()
                } else if items.isEmpty {
                    Spacer()
                    Text("No items available")
                        .font(.agBody)
                        .foregroundColor(.agMediumGrey)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(items) { item in
                                MenuItemCard(item: item) {
                                    selectedItem = item
                                    showDishDetail = true
                                }
                            }
                            StandardFooter()
                        }
                    }
                }
            }

            SideNavigationView(isOpen: $isSideNavOpen)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showDishDetail) {
            if let item = selectedItem {
                DishDetailView(item: item)
            }
        }
        .sheet(isPresented: $isCartOpen) {
            CartView()
        }
    }
}

// MARK: - Dish Detail View

struct DishDetailView: View {
    let item: MenuItem
    @EnvironmentObject var cartStore: CartStore
    @Environment(\.presentationMode) var presentationMode
    @State private var quantity = 1
    @State private var specialInstructions = ""

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.agBlack)
                        .font(.system(size: 20))
                        .frame(width: 44, height: 44)
                }

                Spacer()

                Text("DISH DETAILS")
                    .font(.outfitExtraLight(18))
                    .foregroundColor(.agBlack)
                    .kerning(1.5)

                Spacer()

                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.agBlack)
                        .font(.system(size: 18))
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, AGSpacing.md)
            .overlay(Rectangle().frame(height: 1).foregroundColor(Color.agLightGrey), alignment: .bottom)

            ScrollView {
                VStack(spacing: AGSpacing.xl) {
                    // Image
                    if let urlString = item.imageUrl {
                        AGAsyncImage(urlString: urlString, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .frame(maxHeight: 224)
                    }

                    VStack(spacing: AGSpacing.md) {
                        // Title
                        Text(item.name)
                            .font(.outfitExtraLight(24))
                            .foregroundColor(.agBlack)
                            .multilineTextAlignment(.center)

                        // Description
                        Text(item.description)
                            .font(.agBody)
                            .foregroundColor(.agDarkGrey)
                            .multilineTextAlignment(.center)

                        // Special instructions
                        VStack(alignment: .leading, spacing: AGSpacing.xs) {
                            Text("SPECIAL INSTRUCTIONS")
                                .font(.agButton)
                                .foregroundColor(.agDarkGrey)
                                .kerning(1)

                            TextEditor(text: $specialInstructions)
                                .font(.agBody)
                                .frame(height: 80)
                                .padding(AGSpacing.md)
                                .background(Color(red: 0.953, green: 0.957, blue: 0.965))
                                .cornerRadius(AGRadius.input)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        // Quantity selector
                        HStack {
                            Text("QUANTITY")
                                .font(.agButton)
                                .foregroundColor(.agDarkGrey)
                                .kerning(1)

                            Spacer()

                            HStack(spacing: 0) {
                                Button(action: { if quantity > 1 { quantity -= 1 } }) {
                                    Image(systemName: "minus")
                                        .foregroundColor(quantity > 1 ? .agBlack : .agMediumGrey)
                                        .frame(width: 44, height: 44)
                                }

                                Text("\(quantity)")
                                    .font(.agMenuItemTitle)
                                    .foregroundColor(.agBlack)
                                    .frame(width: 40)

                                Button(action: { quantity += 1 }) {
                                    Image(systemName: "plus")
                                        .foregroundColor(.agBlack)
                                        .frame(width: 44, height: 44)
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: AGRadius.input).stroke(Color.agLightGrey, lineWidth: 1))
                        }

                        // Add to order button
                        Button(action: {
                            cartStore.addItem(item, quantity: quantity, specialInstructions: specialInstructions.isEmpty ? nil : specialInstructions)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("ADD TO ORDER")
                                .agPrimaryButton()
                        }
                    }
                    .padding(.horizontal, AGSpacing.xl)
                    .padding(.bottom, AGSpacing.xxxl)
                }
            }
        }
        .background(Color.agWhite)
    }
}
