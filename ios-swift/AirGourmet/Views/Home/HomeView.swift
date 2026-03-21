import SwiftUI

struct HomeView: View {
    @EnvironmentObject var cartStore: CartStore
    @EnvironmentObject var menuStore: MenuStore
    @State private var isSideNavOpen = false
    @State private var isCartOpen = false
    @State private var selectedCategory: MenuCategory?
    @State private var showCategoryView = false

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                // Header
                AGNavigationHeader(
                    title: "",
                    onMenuTap: { withAnimation { isSideNavOpen = true } },
                    cartCount: cartStore.itemCount,
                    onCartTap: { isCartOpen = true }
                )

                ScrollView {
                    VStack(spacing: 0) {
                        heroSection
                        customOrderSection
                        worldIsYourOysterSection
                        menuCategoryGrid
                        StandardFooter()
                    }
                }
            }

            // Side nav overlay
            SideNavigationView(isOpen: $isSideNavOpen) { destination in
                handleNavigation(destination)
            }
        }
        .sheet(isPresented: $isCartOpen) {
            CartView()
        }
        .background(
            NavigationLink(
                destination: selectedCategory.map { CategoryView(category: $0) },
                isActive: $showCategoryView,
                label: { EmptyView() }
            )
        )
        .task { await menuStore.loadMenu() }
    }

    // MARK: - Sections

    private var heroSection: some View {
        ZStack {
            Color.agBlack
                .frame(height: 240)

            VStack(spacing: AGSpacing.md) {
                // AG Logo placeholder
                Circle()
                    .fill(Color.agWhite.opacity(0.1))
                    .frame(width: 90, height: 88)
                    .overlay(Text("AG").font(.outfitLight(32)).foregroundColor(.agWhite))

                Text("AIR GOURMET\nINFLIGHT CATERING")
                    .font(.outfitLight(16))
                    .foregroundColor(.agWhite)
                    .kerning(2)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
    }

    private var customOrderSection: some View {
        VStack(alignment: .leading, spacing: AGSpacing.lg) {
            Text("OUR MENU IS YOUR IMAGINATION")
                .font(.agCoralHeadline)
                .foregroundColor(.agCoral)
                .kerning(1)
                .padding(.horizontal, AGSpacing.lg)
                .padding(.top, AGSpacing.xl)

            Text("Use our app to order any taste, dish, whim or wish. Choose from our menu, or place custom orders by using the form below. In our decades in the air we've met every kind of need — whatever you can think of, Air Gourmet, the finest dining in the air.")
                .font(.agBody)
                .foregroundColor(.agBlack)
                .padding(.horizontal, AGSpacing.lg)

            // Custom order box
            VStack(alignment: .leading, spacing: AGSpacing.md) {
                Text("CUSTOM ORDER")
                    .font(.agButton)
                    .foregroundColor(.agDarkGrey)
                    .kerning(1)
                Text("Create your custom order.")
                    .font(.agBody)
                    .foregroundColor(.agMediumGrey)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AGSpacing.lg)
            .background(Color.agOffWhite)
            .cornerRadius(AGRadius.card)
            .padding(.horizontal, AGSpacing.lg)

            Button(action: {}) {
                Text("PLACE MY ORDER")
                    .agPrimaryButton()
            }
            .padding(.horizontal, AGSpacing.lg)
        }
        .padding(.bottom, AGSpacing.xl)
    }

    private var worldIsYourOysterSection: some View {
        VStack(spacing: AGSpacing.lg) {
            Text("THE WORLD IS YOUR OYSTER")
                .font(.agSectionTitle)
                .foregroundColor(.agBlack)
                .kerning(1)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AGSpacing.lg)
                .padding(.top, AGSpacing.xl)

            // Globe image placeholder
            Rectangle()
                .fill(Color.agOffWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .overlay(Text("🌍").font(.system(size: 80)))

            Text("INTRODUCING AIR GOURMET GLOBAL")
                .font(.outfitLight(16))
                .foregroundColor(.agBlack)
                .kerning(1)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AGSpacing.lg)

            Text("We're the one-stop shop that makes it easy to enjoy fresh, delicious catering on every leg of your flight. To connect with our global network of fine caterers, just fill out the 'Custom Order' form above. Or call us anytime, 24/7.")
                .font(.agBody)
                .foregroundColor(.agBlack)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AGSpacing.lg)
                .padding(.bottom, AGSpacing.xl)
        }
    }

    private var menuCategoryGrid: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("OUR INFLIGHT MENU")
                .font(.agSectionTitle)
                .foregroundColor(.agBlack)
                .kerning(1)
                .padding(.horizontal, AGSpacing.lg)
                .padding(.vertical, AGSpacing.xl)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 0) {
                ForEach(MenuCategory.allCases) { category in
                    CategoryCard(category: category) {
                        selectedCategory = category
                        showCategoryView = true
                    }
                }
            }
        }
    }

    private func handleNavigation(_ destination: String) {
        if let category = MenuCategory.allCases.first(where: { $0.rawValue == destination }) {
            selectedCategory = category
            showCategoryView = true
        }
    }
}

struct CategoryCard: View {
    let category: MenuCategory
    var onTap: (() -> Void)?

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(Color.agOffWhite)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Text(category.rawValue.prefix(1))
                            .font(.outfitLight(48))
                            .foregroundColor(.agMediumGrey)
                    )

                Text(category.rawValue.uppercased())
                    .font(.agMenuItemTitle)
                    .foregroundColor(.agBlack)
                    .kerning(0.5)
                    .padding(AGSpacing.md)
            }
            .background(Color.agWhite)
            .cornerRadius(AGRadius.card)
            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(AGSpacing.xs)
    }
}
