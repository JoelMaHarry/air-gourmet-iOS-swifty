import SwiftUI

struct HomeView: View {
    @EnvironmentObject var cartStore: CartStore
    @EnvironmentObject var menuStore: MenuStore
    @State private var isSideNavOpen = false
    @State private var selectedCategory: MenuCategory?
    @State private var showCategoryView = false
    @State private var customOrderText = ""

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                homeHeader
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        heroImageSection
                        introSection
                        customOrderSection
                        divider
                        oysterSection
                        jetBannerSection
                        categoryGridSection
                        conciergeSection
                        thirtyYearsBannerSection
                        StandardFooter()
                    }
                }
            }
            SideNavigationView(isOpen: $isSideNavOpen) { destination in
                if let cat = MenuCategory.allCases.first(where: { $0.rawValue == destination }) {
                    selectedCategory = cat
                    showCategoryView = true
                }
            }
            NavigationLink(
                destination: selectedCategory.map { CategoryView(category: $0) },
                isActive: $showCategoryView,
                label: { EmptyView() }
            )
        }
        .task { await menuStore.loadMenu() }
    }

    // ─────────────────────────────────────────
    // MARK: 1. HOME HEADER (black)
    // Figma: Hero Header Background y=-49 h=240
    // Logo at y=28, title at y=141
    // Fruit image at y=208 — below this header
    // ─────────────────────────────────────────
    private var homeHeader: some View {
        ZStack(alignment: .top) {
            Color.black

            // Hamburger + profile row at top
            HStack {
                Button(action: { withAnimation { isSideNavOpen = true } }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "#FF6348"))
                        .frame(width: 44, height: 44)
                }
                .padding(.leading, 8)
                .padding(.top, 8)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "person")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "#FF6348"))
                        .frame(width: 44, height: 44)
                }
                .padding(.trailing, 8)
                .padding(.top, 8)
            }

            // Logo + title centered in the black zone
            VStack(spacing: 8) {
                Spacer().frame(height: 28)
                Image("ag-symbol-white")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 88)
                Text("AIR GOURMET INFLIGHT CATERING")
                    .font(.outfitLight(16))
                    .foregroundColor(.white)
                    .kerning(0.9)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(height: 191)
    }

    // ─────────────────────────────────────────
    // Figma: FearturedDishes at y=208, h=179
    // sits BELOW the black header on white bg
    // ─────────────────────────────────────────

    // ─────────────────────────────────────────
    // MARK: 2. HERO IMAGE
    // Figma: x=383, y=208, w=319, h=179
    // Floating on white, no border/box
    // ─────────────────────────────────────────
    private var heroImageSection: some View {
        Image("featured-dishes")
            .resizable()
            .scaledToFit()
            .frame(width: 319)
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
            .padding(.bottom, 4)
    }

    // ─────────────────────────────────────────
    // MARK: 3. INTRO TEXT BLOCK
    // coral headline + body copy
    // ─────────────────────────────────────────
    private var introSection: some View {
        VStack(spacing: 10) {
            Text("OUR MENU IS YOUR IMAGINATION")
                .font(.outfitLight(16))
                .foregroundColor(Color(hex: "#FF6348"))
                .kerning(0.8)
                .multilineTextAlignment(.center)
                .padding(.top, 12)

            Text("Use our app to meet any taste, diet, whim or wish. Choose from our menu, or place custom orders by using the form below. In our decades in the air we've met every kind of request you can think of. Air Gourmet. The finest dining in the air.")
                .font(Font.custom("Hanuman-Medium", size: 15))
                .foregroundColor(Color(hex: "#6B6B6B"))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
        }
        .background(Color.white)
    }

    // ─────────────────────────────────────────
    // MARK: 4. CUSTOM ORDER MODULE
    // coral-bordered box + button
    // ─────────────────────────────────────────
    private var customOrderSection: some View {
        VStack(spacing: 8) {
            // Text area with coral border
            VStack(spacing: 0) {
                Text("TAP TO WRITE YOUR CUSTOM ORDER")
                    .font(.outfitLight(11))
                    .foregroundColor(Color(hex: "#6B6B6B"))
                    .kerning(0.8)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                    .padding(.horizontal, 12)

                ZStack(alignment: .topLeading) {
                    if customOrderText.isEmpty {
                        Text("Type here to create your custom order")
                            .font(Font.custom("Hanuman-Medium", size: 14))
                            .foregroundColor(Color(hex: "#AAAAAA"))
                            .padding(.horizontal, 14)
                            .padding(.top, 8)
                    }
                    TextEditor(text: $customOrderText)
                        .font(Font.custom("Hanuman-Medium", size: 14))
                        .foregroundColor(Color(hex: "#6B6B6B"))
                        .frame(height: 80)
                        .padding(.horizontal, 8)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                }
                .padding(.bottom, 8)
            }
            .background(Color(hex: "#FF6348").opacity(0.04))
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(hex: "#FF6348"), lineWidth: 1))
            .padding(.horizontal, 24)

            // Place My Order button
            Button(action: {}) {
                Text("PLACE MY ORDER")
                    .font(.outfitLight(13))
                    .foregroundColor(.white)
                    .kerning(0.7)
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .background(Color(hex: "#FF6348"))
                    .cornerRadius(6)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .background(Color.white)
    }

    // ─────────────────────────────────────────
    // MARK: 5. DIVIDER
    // ─────────────────────────────────────────
    private var divider: some View {
        Rectangle()
            .fill(Color(hex: "#EBEBEB"))
            .frame(height: 1)
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
    }

    // ─────────────────────────────────────────
    // MARK: 6. OYSTER SECTION
    // title + image + AG Global copy
    // ─────────────────────────────────────────
    private var oysterSection: some View {
        VStack(spacing: 10) {
            Text("THE WORLD IS YOUR OYSTER")
                .font(.outfitLight(18))
                .foregroundColor(.black)
                .kerning(1.2)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            Image("oyster-world")
                .resizable()
                .scaledToFit()
                .frame(width: 260)
                .padding(.vertical, 8)

            Text("INTRODUCING AIR GOURMET GLOBAL")
                .font(.outfitLight(13))
                .foregroundColor(Color(hex: "#FF6348"))
                .kerning(0.7)
                .multilineTextAlignment(.center)

            Text("We're the one-stop shop that makes it easy to enjoy fresh, fabulous catering on every leg of your flight. To connect with our global network of fine caterers, just hit the \"Custom Order\" form above. Or call us anytime, 24/7.")
                .font(Font.custom("Hanuman-Medium", size: 15))
                .foregroundColor(Color(hex: "#6B6B6B"))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
        }
        .background(Color.white)
    }

    // ─────────────────────────────────────────
    // MARK: 7. JET BANNER (OUR INFLIGHT MENU)
    // full-width image with text overlay
    // ─────────────────────────────────────────
    private var jetBannerSection: some View {
        ZStack {
            Image("menu-banner")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .clipped()

            Color.black.opacity(0.35)
                .frame(height: 160)

            Text("OUR INFLIGHT MENU")
                .font(.outfitLight(18))
                .foregroundColor(.white)
                .kerning(0.9)
        }
        .frame(height: 160)
    }

    // ─────────────────────────────────────────
    // MARK: 8. CATEGORY GRID
    // 2-column, food photos + labels below
    // ─────────────────────────────────────────
    private var categoryGridSection: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
            spacing: 12
        ) {
            ForEach(MenuCategory.allCases) { category in
                Button(action: {
                    selectedCategory = category
                    showCategoryView = true
                }) {
                    VStack(spacing: 0) {
                        Image(category.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 110)
                            .clipped()
                            .cornerRadius(6)

                        Text(category.rawValue.uppercased())
                            .font(.outfitLight(11))
                            .foregroundColor(Color(hex: "#6B6B6B"))
                            .kerning(0.6)
                            .multilineTextAlignment(.center)
                            .padding(.top, 6)
                            .padding(.bottom, 10)
                    }
                    .background(Color.white)
                    .cornerRadius(6)
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 2, y: 2)
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
    }

    // ─────────────────────────────────────────
    // MARK: 9. CONCIERGE SECTION
    // flowers image + title + body copy
    // ─────────────────────────────────────────
    private var conciergeSection: some View {
        VStack(spacing: 0) {
            Image("concierge-image")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .clipped()

            Text("CONCIERGE SERVICES")
                .font(.outfitLight(16))
                .foregroundColor(.black)
                .kerning(0.9)
                .padding(.top, 16)
                .padding(.bottom, 8)

            Text("We provide the accoutrements that soften the rigors of flying – simple things, like suggesting the flowers for the decoration of your aircraft. We can provide you with everything from cigars, videos, linen service, cabin supplies, gifts, personal shopping, newspapers, transportation services – whatever your special needs might be.")
                .font(Font.custom("Hanuman-Medium", size: 15))
                .foregroundColor(Color(hex: "#6B6B6B"))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
        }
        .background(Color.white)
    }

    // ─────────────────────────────────────────
    // MARK: 10. 30 YEARS BANNER
    // sunset sky image + text overlay
    // ─────────────────────────────────────────
    private var thirtyYearsBannerSection: some View {
        ZStack {
            Image("thirty-years-bg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 220)
                .clipped()

            Color.black.opacity(0.35)
                .frame(height: 220)

            VStack(spacing: 10) {
                Text("30 YEARS OF TAKING CATERING HIGHER")
                    .font(.outfitLight(14))
                    .foregroundColor(.white)
                    .kerning(0.7)
                    .multilineTextAlignment(.center)

                Text("We've been dedicated to helping aviation pros like you for 30 years. Our team is standing by, so please reach out to us. We love to talk catering and supporting our clients in the air.")
                    .font(Font.custom("Hanuman-Medium", size: 15))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.horizontal, 32)
            }
        }
        .frame(height: 220)
    }
}

// MARK: - Color hex helper (shared)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a,r,g,b) = (255,(int>>8)*17,(int>>4 & 0xF)*17,(int & 0xF)*17)
        case 6:  (a,r,g,b) = (255,int>>16,int>>8 & 0xFF,int & 0xFF)
        case 8:  (a,r,g,b) = (int>>24,int>>16 & 0xFF,int>>8 & 0xFF,int & 0xFF)
        default: (a,r,g,b) = (255,0,0,0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
