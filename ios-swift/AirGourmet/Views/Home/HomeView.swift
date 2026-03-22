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
                // ── BLACK HEADER ──────────────────────────
                // Contains ONLY icons + logo + title
                // Figma: Hero Header Background h=240 (incl safe area offset)
                // ─────────────────────────────────────────
                ZStack(alignment: .top) {
                    Color.black

                    // Icons row — top of header
                    HStack {
                        Button(action: { withAnimation { isSideNavOpen = true } }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(Color(hex: "#FF6348"))
                                .frame(width: 44, height: 44)
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "person")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(Color(hex: "#FF6348"))
                                .frame(width: 44, height: 44)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 4)

                    // Logo + title — centered in black zone
                    // Figma: AG Symbol y=28, title y=141
                    VStack(spacing: 10) {
                        Image("ag-symbol-white")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 88)
                            .padding(.top, 28)
                        Text("AIR GOURMET INFLIGHT CATERING")
                            .font(.outfitLight(16))
                            .foregroundColor(.white)
                            .kerning(0.9)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                    }
                }
                .frame(height: 191)

                // ── SCROLL CONTENT ────────────────────────
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        // ── SECTION 1: FRUIT IMAGE ────────
                        // Figma: FearturedDishes y=208, w=319, h=179
                        // Sits on white, not clipped, full scaledToFit
                        Image("featured-dishes")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 319)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            .padding(.bottom, 12)
                            .background(Color.white)

                        // ── SECTION 2: INTRO TEXT ─────────
                        VStack(spacing: 8) {
                            Text("OUR MENU IS YOUR IMAGINATION")
                                .font(.outfitLight(16))
                                .foregroundColor(Color(hex: "#FF6348"))
                                .kerning(0.8)
                                .multilineTextAlignment(.center)

                            Text("Use our app to meet any taste, diet, whim or wish. Choose from our menu, or place custom orders by using the form below. In our decades in the air we've met every kind of request you can think of. Air Gourmet. The finest dining in the air.")
                                .font(Font.custom("Hanuman-Medium", size: 14))
                                .foregroundColor(Color(hex: "#6B6B6B"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(Color.white)

                        // ── SECTION 3: CUSTOM ORDER ───────
                        // Coral border box + button below
                        VStack(spacing: 8) {
                            VStack(spacing: 4) {
                                Text("TAP TO WRITE YOUR CUSTOM ORDER")
                                    .font(.outfitLight(11))
                                    .foregroundColor(Color(hex: "#6B6B6B"))
                                    .kerning(0.8)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 10)

                                TextEditor(text: $customOrderText)
                                    .font(Font.custom("Hanuman-Medium", size: 13))
                                    .foregroundColor(customOrderText.isEmpty ? Color(hex: "#AAAAAA") : Color(hex: "#6B6B6B"))
                                    .frame(height: 64)
                                    .padding(.horizontal, 8)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .padding(.bottom, 4)
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#FF6348").opacity(0.04))
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(hex: "#FF6348"), lineWidth: 1))

                            Button(action: {}) {
                                Text("PLACE MY ORDER")
                                    .font(.outfitLight(13))
                                    .foregroundColor(.white)
                                    .kerning(0.7)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 36)
                                    .background(Color(hex: "#FF6348"))
                                    .cornerRadius(6)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                        .background(Color.white)

                        // ── DIVIDER ───────────────────────
                        Rectangle()
                            .fill(Color(hex: "#EBEBEB"))
                            .frame(height: 1)
                            .padding(.horizontal, 24)

                        // ── SECTION 4: OYSTER ─────────────
                        VStack(spacing: 8) {
                            Text("THE WORLD IS YOUR OYSTER")
                                .font(.outfitLight(18))
                                .foregroundColor(.black)
                                .kerning(1.2)
                                .multilineTextAlignment(.center)
                                .padding(.top, 20)

                            Image("oyster-world")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 260)
                                .padding(.vertical, 8)

                            Text("INTRODUCING AIR GOURMET GLOBAL")
                                .font(.outfitLight(12))
                                .foregroundColor(Color(hex: "#FF6348"))
                                .kerning(0.7)
                                .multilineTextAlignment(.center)

                            Text("We're the one-stop shop that makes it easy to enjoy fresh, fabulous catering on every leg of your flight. To connect with our global network of fine caterers, just hit the \"Custom Order\" form above. Or call us anytime, 24/7.")
                                .font(Font.custom("Hanuman-Medium", size: 14))
                                .foregroundColor(Color(hex: "#6B6B6B"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 24)
                                .padding(.bottom, 20)
                        }
                        .background(Color.white)

                        // ── SECTION 5: JET BANNER ─────────
                        ZStack {
                            Image("menu-banner")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .clipped()
                            Color.black.opacity(0.3).frame(height: 150)
                            Text("OUR INFLIGHT MENU")
                                .font(.outfitLight(16))
                                .foregroundColor(.white)
                                .kerning(0.9)
                        }
                        .frame(height: 150)

                        // ── SECTION 6: CATEGORY GRID ──────
                        LazyVGrid(
                            columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                            spacing: 10
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
                                            .frame(height: 100)
                                            .clipped()
                                            .cornerRadius(6)
                                        Text(category.rawValue.uppercased())
                                            .font(.outfitLight(11))
                                            .foregroundColor(Color(hex: "#6B6B6B"))
                                            .kerning(0.6)
                                            .multilineTextAlignment(.center)
                                            .padding(.vertical, 6)
                                    }
                                    .background(Color.white)
                                    .cornerRadius(6)
                                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 1, y: 1)
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                        .background(Color.white)

                        // ── SECTION 7: CONCIERGE ──────────
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
                                .padding(.top, 14)
                                .padding(.bottom, 8)
                            Text("We provide the accoutrements that soften the rigors of flying – simple things, like suggesting the flowers for the decoration of your aircraft. We can provide you with everything from cigars, videos, linen service, cabin supplies, gifts, personal shopping, newspapers, transportation services – whatever your special needs might be.")
                                .font(Font.custom("Hanuman-Medium", size: 14))
                                .foregroundColor(Color(hex: "#6B6B6B"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 24)
                                .padding(.bottom, 20)
                        }
                        .background(Color.white)

                        // ── SECTION 8: 30 YEARS BANNER ────
                        ZStack {
                            Image("thirty-years-bg")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .clipped()
                            Color.black.opacity(0.35).frame(height: 200)
                            VStack(spacing: 8) {
                                Text("30 YEARS OF TAKING CATERING HIGHER")
                                    .font(.outfitLight(13))
                                    .foregroundColor(.white)
                                    .kerning(0.7)
                                    .multilineTextAlignment(.center)
                                Text("We've been dedicated to helping aviation pros like you for 30 years. Our team is standing by, so please reach out to us. We love to talk catering and supporting our clients in the air.")
                                    .font(Font.custom("Hanuman-Medium", size: 14))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.horizontal, 32)
                            }
                        }
                        .frame(height: 200)

                        // ── SECTION 9: FOOTER ─────────────
                        StandardFooter()
                    }
                }
            }

            // Side nav overlay
            SideNavigationView(isOpen: $isSideNavOpen) { destination in
                if let cat = MenuCategory.allCases.first(where: { $0.rawValue == destination }) {
                    selectedCategory = cat
                    showCategoryView = true
                }
            }

            // Hidden nav link
            NavigationLink(
                destination: selectedCategory.map { CategoryView(category: $0) },
                isActive: $showCategoryView,
                label: { EmptyView() }
            )
        }
        .task { await menuStore.loadMenu() }
    }
}
