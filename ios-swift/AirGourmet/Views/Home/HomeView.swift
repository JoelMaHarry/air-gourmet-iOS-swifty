import SwiftUI

struct HomeView: View {
    @EnvironmentObject var cartStore: CartStore
    @EnvironmentObject var menuStore: MenuStore
    @State private var isSideNavOpen = false
    @State private var isCartOpen = false
    @State private var selectedCategory: MenuCategory?
    @State private var showCategoryView = false
    @State private var customOrderText = ""

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

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        heroSection
                        customOrderSection
                        worldIsYourOysterSection
                        menuSection
                        conciergeSection
                        thirtyYearsSection
                        StandardFooter()
                    }
                }
            }

            SideNavigationView(isOpen: $isSideNavOpen) { destination in
                if let category = MenuCategory.allCases.first(where: { $0.rawValue == destination }) {
                    selectedCategory = category
                    showCategoryView = true
                }
            }

            // Hidden navigation link
            NavigationLink(
                destination: selectedCategory.map { CategoryView(category: $0) },
                isActive: $showCategoryView,
                label: { EmptyView() }
            )
        }
        .sheet(isPresented: $isCartOpen) { CartView() }
        .task { await menuStore.loadMenu() }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        ZStack(alignment: .top) {
            // Black background
            Color.agBlack
                .frame(height: 240)

            VStack(spacing: 0) {
                // AG Logo
                Image("ag-symbol")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 88)
                    .padding(.top, 28)

                // Featured dishes image
                Image("featured-dishes")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 319, height: 100)
                    .clipped()
                    .padding(.top, 8)

                // Title
                Text("AIR GOURMET INFLIGHT CATERING")
                    .font(.outfitLight(18))
                    .foregroundColor(.agWhite)
                    .kerning(0.9)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
            }
        }
        .frame(height: 240)
        .clipped()
    }

    // MARK: - Custom Order Section

    private var customOrderSection: some View {
        VStack(alignment: .leading, spacing: AGSpacing.lg) {
            // Coral headline
            Text("OUR MENU IS YOUR IMAGINATION")
                .font(.outfitLight(18))
                .foregroundColor(.agCoral)
                .kerning(0.9)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, AGSpacing.xl)
                .padding(.horizontal, AGSpacing.lg)

            // Body copy
            Text("Use our app to meet any taste, diet, whim or wish. Choose from our menu, or place custom orders by using the form below. In our decades in the air we've met every kind of request you can think of. Air Gourmet. The finest dining in the air.")
                .font(.hanumanMedium(16))
                .foregroundColor(Color(red: 0.42, green: 0.42, blue: 0.42))
                .multilineTextAlignment(.center)
                .lineSpacing(9)
                .padding(.horizontal, AGSpacing.lg)

            // Custom order box - coral border
            VStack(alignment: .leading, spacing: AGSpacing.xs) {
                Text("TAP TO WRITE YOUR CUSTOM ORDER")
                    .font(.outfitLight(14))
                    .foregroundColor(.agDarkGrey)
                    .kerning(0.7)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                TextEditor(text: $customOrderText)
                    .font(.hanumanMedium(16))
                    .foregroundColor(.agMediumGrey)
                    .frame(height: 60)
                    .background(Color.clear)
            }
            .padding(AGSpacing.lg)
            .background(Color(red: 1.0, green: 0.388, blue: 0.282).opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.agCoral, lineWidth: 1)
            )
            .cornerRadius(6)
            .padding(.horizontal, AGSpacing.lg)

            // Place My Order button
            Button(action: {}) {
                Text("PLACE MY ORDER")
                    .font(.outfitLight(14))
                    .foregroundColor(.agWhite)
                    .kerning(0.7)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.agCoral)
                    .cornerRadius(AGRadius.button)
            }
            .padding(.horizontal, AGSpacing.lg)
            .padding(.bottom, AGSpacing.xl)
        }
    }

    // MARK: - World Is Your Oyster Section

    private var worldIsYourOysterSection: some View {
        VStack(spacing: 0) {
            // Divider
            Rectangle()
                .fill(Color.agLightGrey)
                .frame(height: 1)
                .padding(.horizontal, AGSpacing.lg)

            // THE WORLD IS YOUR OYSTER
            Text("THE WORLD IS YOUR OYSTER")
                .font(.outfitLight(20))
                .foregroundColor(.agBlack)
                .kerning(1.6)
                .multilineTextAlignment(.center)
                .padding(.top, AGSpacing.xl)
                .padding(.horizontal, AGSpacing.lg)

            // Oyster/Globe image
            Image("oyster-world")
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 211)
                .clipped()
                .cornerRadius(6)
                .padding(.top, AGSpacing.lg)

            // AG Global section
            VStack(spacing: AGSpacing.md) {
                Text("INTRODUCING AIR GOURMET GLOBAL")
                    .font(.outfitLight(14))
                    .foregroundColor(.agCoral)
                    .kerning(0.7)
                    .multilineTextAlignment(.center)

                Text("We're the one-stop shop that makes it easy to enjoy fresh, delicious catering on every leg of your flight. To connect with our global network of fine caterers, just fill out the \"Custom Order\" form above. Or call us anytime, 24/7.")
                    .font(.hanumanMedium(16))
                    .foregroundColor(Color(red: 0.42, green: 0.42, blue: 0.42))
                    .multilineTextAlignment(.center)
                    .lineSpacing(9)
            }
            .padding(.horizontal, AGSpacing.lg)
            .padding(.vertical, AGSpacing.xl)
        }
    }

    // MARK: - Menu Section

    private var menuSection: some View {
        VStack(spacing: 0) {
            // Menu banner with background image
            ZStack {
                Image("menu-banner")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 175)
                    .clipped()

                Color.agBlack.opacity(0.4)
                    .frame(height: 175)

                Text("OUR INFLIGHT MENU")
                    .font(.outfitLight(18))
                    .foregroundColor(.agWhite)
                    .kerning(0.9)
            }
            .frame(height: 175)

            // Category grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(MenuCategory.allCases) { category in
                    MenuCategoryCard(category: category) {
                        selectedCategory = category
                        showCategoryView = true
                    }
                }
            }
            .padding(.horizontal, AGSpacing.md)
            .padding(.vertical, AGSpacing.lg)
        }
    }

    // MARK: - Concierge Section

    private var conciergeSection: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.agLightGrey)
                .frame(height: 1)
                .padding(.horizontal, AGSpacing.lg)
                .padding(.vertical, AGSpacing.xl)

            Text("CONCIERGE SERVICES")
                .font(.outfitLight(18))
                .foregroundColor(.agBlack)
                .kerning(0.9)
                .padding(.bottom, AGSpacing.lg)

            // Concierge image
            Image("concierge-image")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 233)
                .clipped()
                .cornerRadius(6)
                .padding(.horizontal, AGSpacing.lg)

            Text("We provide the accoutrements that soften the rigors of flying — simple things, like suggesting the flowers for the decoration of your aircraft. We can provide you with everything from cigars, videos, linen service, cabin supplies, gifts, personal shopping, newspapers, transportation services — whatever your special needs might be.")
                .font(.hanumanMedium(16))
                .foregroundColor(Color(red: 0.42, green: 0.42, blue: 0.42))
                .multilineTextAlignment(.center)
                .lineSpacing(9)
                .padding(.horizontal, AGSpacing.lg)
                .padding(.top, AGSpacing.lg)
                .padding(.bottom, AGSpacing.xl)
        }
    }

    // MARK: - 30 Years Section

    private var thirtyYearsSection: some View {
        ZStack {
            Image("thirty-years-bg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 242)
                .clipped()

            Color.agBlack.opacity(0.5)

            VStack(spacing: AGSpacing.md) {
                Text("30 YEARS OF TAKING CATERING HIGHER")
                    .font(.outfitLight(14))
                    .foregroundColor(.agWhite)
                    .kerning(0.7)
                    .multilineTextAlignment(.center)

                Text("We've been dedicated to helping aviation pros like you for 30 years. Our team is standing by, so please reach out to us. We love to talk catering and supporting our clients in the air.")
                    .font(.hanumanMedium(16))
                    .foregroundColor(.agWhite)
                    .multilineTextAlignment(.center)
                    .lineSpacing(9)
            }
            .padding(.horizontal, AGSpacing.lg)
        }
        .frame(height: 242)
    }
}

// MARK: - Menu Category Card

struct MenuCategoryCard: View {
    let category: MenuCategory
    var onTap: (() -> Void)?

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .center, spacing: 0) {
                // Category image
                Image(category.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .clipped()
                    .cornerRadius(6)

                // Category name
                Text(category.rawValue.uppercased())
                    .font(.outfitLight(12))
                    .foregroundColor(Color(red: 0.42, green: 0.42, blue: 0.42))
                    .kerning(0.6)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, AGSpacing.xs)
            }
            .background(Color.agWhite)
            .cornerRadius(6)
            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 2, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
