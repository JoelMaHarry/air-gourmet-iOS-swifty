import SwiftUI

// MARK: - Navigation Header

struct AGNavigationHeader: View {
    let title: String
    var onMenuTap: (() -> Void)?
    var cartCount: Int = 0
    var onCartTap: (() -> Void)?
    var showBackButton: Bool = false
    var onBackTap: (() -> Void)?

    var body: some View {
        HStack {
            // Left - hamburger or back
            if showBackButton {
                Button(action: { onBackTap?() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.agWhite)
                        .font(.system(size: 20))
                        .frame(width: 44, height: 44)
                }
            } else {
                Button(action: { onMenuTap?() }) {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.agCoral)
                        .font(.system(size: 20))
                        .frame(width: 44, height: 44)
                }
            }

            Spacer()

            // Center - title
            Text(title)
                .font(.agPageTitle)
                .foregroundColor(.agWhite)
                .kerning(1.5)

            Spacer()

            // Right - cart
            if cartCount > 0 {
                Button(action: { onCartTap?() }) {
                    HStack(spacing: 4) {
                        Text("CART")
                            .font(.agButton)
                            .foregroundColor(.agCoral)
                        Text("\(cartCount)")
                            .font(.agButton)
                            .foregroundColor(.agCoral)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 44)
                    .overlay(RoundedRectangle(cornerRadius: AGRadius.button).stroke(Color.agCoral, lineWidth: 1))
                }
            } else {
                Color.clear.frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, AGSpacing.md)
        .padding(.top, AGSpacing.md)
        .padding(.bottom, AGSpacing.xs)
        .background(Color.agBlack)
    }
}

// MARK: - Tab Bar

enum AGTab: CaseIterable {
    case home, custom, menu, search, profile

    var label: String {
        switch self {
        case .home: return "HOME"
        case .custom: return "CUSTOM"
        case .menu: return "MENU"
        case .search: return "SEARCH"
        case .profile: return "PROFILE"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house"
        case .custom: return "square.and.pencil"
        case .menu: return "menucard"
        case .search: return "magnifyingglass"
        case .profile: return "person"
        }
    }
}

struct AGTabBar: View {
    @Binding var selectedTab: AGTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AGTab.allCases, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20))
                        Text(tab.label)
                            .font(.system(size: 10))
                            .kerning(0.5)
                    }
                    .foregroundColor(selectedTab == tab ? .agCoral : .agMediumGrey)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                }
            }
        }
        .background(Color.agWhite.opacity(0.95))
        .overlay(Rectangle().frame(height: 1).foregroundColor(Color.agLightGrey), alignment: .top)
    }
}

// MARK: - Side Navigation

struct SideNavigationView: View {
    @Binding var isOpen: Bool
    var onNavigate: ((String) -> Void)?

    var body: some View {
        ZStack(alignment: .leading) {
            // Overlay
            if isOpen {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { isOpen = false } }
            }

            // Drawer
            if isOpen {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    HStack {
                        Spacer()
                        Button(action: { withAnimation { isOpen = false } }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.agBlack)
                                .font(.system(size: 18))
                                .frame(width: 44, height: 44)
                        }
                    }
                    .padding(AGSpacing.md)
                    .overlay(Rectangle().frame(height: 1).foregroundColor(Color.agLightGrey), alignment: .bottom)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            navItem("HOME") { onNavigate?("home"); withAnimation { isOpen = false } }
                            
                            Text("MENU")
                                .font(.system(size: 11))
                                .foregroundColor(.agMediumGrey)
                                .kerning(1)
                                .padding(.horizontal, AGSpacing.lg)
                                .padding(.top, AGSpacing.lg)
                                .padding(.bottom, AGSpacing.xs)

                            ForEach(MenuCategory.allCases) { category in
                                navItem(category.rawValue.uppercased()) {
                                    onNavigate?(category.rawValue)
                                    withAnimation { isOpen = false }
                                }
                            }

                            Divider().padding(.vertical, AGSpacing.md)

                            navItem("ABOUT") { onNavigate?("about"); withAnimation { isOpen = false } }
                            navItem("CONTACT") { onNavigate?("contact"); withAnimation { isOpen = false } }
                            navItem("PROFILE") { onNavigate?("profile"); withAnimation { isOpen = false } }
                        }
                    }
                    Spacer()
                }
                .frame(width: 256)
                .background(Color(red: 0.937, green: 0.937, blue: 0.937))
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isOpen)
    }

    private func navItem(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.agNavItem)
                .foregroundColor(.agBlack)
                .kerning(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, AGSpacing.lg)
                .padding(.vertical, AGSpacing.xs + 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Menu Item Card

struct MenuItemCard: View {
    let item: MenuItem
    var onTap: (() -> Void)?

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: 0) {
                AGAsyncImage(urlString: item.imageUrl)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(3/2, contentMode: .fit)
                    .clipped()

                VStack(alignment: .leading, spacing: AGSpacing.xs) {
                    Text(item.name)
                        .font(.agMenuItemTitle)
                        .foregroundColor(.agBlack)
                        .lineSpacing(1.1)
                        .multilineTextAlignment(.leading)

                    Text(item.description)
                        .font(.agMenuItemDescription)
                        .foregroundColor(.agDarkGrey)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(AGSpacing.lg)
                .padding(.bottom, AGSpacing.xxl)
            }
            .background(Color.agWhite)
            .cornerRadius(AGRadius.card)
            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal, AGSpacing.sm)
        .padding(.vertical, AGSpacing.sm)
    }
}

// MARK: - Button Styles

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Standard Footer

struct StandardFooter: View {
    var body: some View {
        VStack(spacing: AGSpacing.xxl) {
            Divider()
                .padding(.vertical, AGSpacing.xxxl)

            Text("Questions? Concerns?")
                .font(.hanumanMedium(18))
                .foregroundColor(.agCoral)

            Text("OUR MENU IS YOUR IMAGINATION")
                .font(.outfitLight(18))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .kerning(1)
                .multilineTextAlignment(.center)

            // Logo placeholder
            Circle()
                .fill(Color.agOffWhite)
                .frame(width: 82, height: 82)
                .overlay(Text("AG").font(.outfitLight(24)).foregroundColor(.agBlack))

            VStack(spacing: AGSpacing.xs) {
                Text("LOS ANGELES  702.457.0500 | 702.459.0589")
                    .font(.hanumanMedium(14))
                    .foregroundColor(.agBlack)
                Text("NATIONWIDE  800.222.2466 | 602.275.4601")
                    .font(.hanumanMedium(14))
                    .foregroundColor(.agBlack)
            }

            Text("AIR-GOURMET.COM")
                .font(.outfitLight(16))
                .foregroundColor(.agBlack)
                .kerning(1)
        }
        .padding(.horizontal, AGSpacing.lg)
        .padding(.bottom, AGSpacing.xxxl)
        .multilineTextAlignment(.center)
    }
}
