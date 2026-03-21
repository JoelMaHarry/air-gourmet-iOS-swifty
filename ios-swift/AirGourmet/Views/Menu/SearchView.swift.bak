import SwiftUI

struct SearchView: View {
    @EnvironmentObject var menuStore: MenuStore
    @EnvironmentObject var cartStore: CartStore
    @State private var searchText = ""
    @State private var selectedItem: MenuItem?
    @State private var showDishDetail = false

    var results: [MenuItem] {
        guard !searchText.isEmpty else { return [] }
        return menuStore.allItems.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("SEARCH")
                .font(.agSectionTitle)
                .foregroundColor(.agBlack)
                .kerning(1.5)
                .padding(.top, AGSpacing.xl)
                .padding(.bottom, AGSpacing.md)

            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.agMediumGrey)
                TextField("Search menu...", text: $searchText)
                    .font(.agBody)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.agMediumGrey)
                    }
                }
            }
            .padding(AGSpacing.md)
            .background(Color.agOffWhite)
            .cornerRadius(AGRadius.input)
            .padding(.horizontal, AGSpacing.lg)
            .padding(.bottom, AGSpacing.md)

            Divider()

            if searchText.isEmpty {
                Spacer()
                Text("Search for dishes, categories, or ingredients")
                    .font(.agBody)
                    .foregroundColor(.agMediumGrey)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AGSpacing.lg)
                Spacer()
            } else if results.isEmpty {
                Spacer()
                Text("No results for \"\(searchText)\"")
                    .font(.agBody)
                    .foregroundColor(.agMediumGrey)
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(results) { item in
                            MenuItemCard(item: item) {
                                selectedItem = item
                                showDishDetail = true
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showDishDetail) {
            if let item = selectedItem {
                DishDetailView(item: item)
            }
        }
    }
}
