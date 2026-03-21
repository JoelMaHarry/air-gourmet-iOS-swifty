import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var cartStore: CartStore
    @State private var selectedTab: AGTab = .home

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Main content
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView()
                    case .custom:
                        HomeView() // scrolls to custom section
                    case .menu:
                        MenuTabView()
                    case .search:
                        SearchView()
                    case .profile:
                        ProfileView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 64) // tab bar height

                // Tab bar
                VStack(spacing: 0) {
                    Spacer()
                    AGTabBar(selectedTab: $selectedTab)
                        .frame(height: 64)
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

struct MenuTabView: View {
    @EnvironmentObject var cartStore: CartStore
    @EnvironmentObject var menuStore: MenuStore
    @State private var selectedCategory: MenuCategory?
    @State private var showCategory = false
    @State private var isSideNavOpen = false
    @State private var isCartOpen = false

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                AGNavigationHeader(
                    title: "MENU",
                    onMenuTap: { withAnimation { isSideNavOpen = true } },
                    cartCount: cartStore.itemCount,
                    onCartTap: { isCartOpen = true }
                )

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(MenuCategory.allCases) { category in
                            Button(action: {
                                selectedCategory = category
                                showCategory = true
                            }) {
                                HStack {
                                    Text(category.rawValue.uppercased())
                                        .font(.agMenuItemTitle)
                                        .foregroundColor(.agBlack)
                                        .kerning(0.5)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.agMediumGrey)
                                }
                                .padding(.horizontal, AGSpacing.lg)
                                .padding(.vertical, AGSpacing.lg)
                            }
                            Divider()
                                .padding(.horizontal, AGSpacing.lg)
                        }
                        StandardFooter()
                    }
                }

                NavigationLink(
                    destination: selectedCategory.map { CategoryView(category: $0) },
                    isActive: $showCategory,
                    label: { EmptyView() }
                )
            }

            SideNavigationView(isOpen: $isSideNavOpen)
        }
        .sheet(isPresented: $isCartOpen) { CartView() }
    }
}
