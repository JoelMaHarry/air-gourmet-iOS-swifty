import SwiftUI

@MainActor
class MenuStore: ObservableObject {
    @Published var allItems: [MenuItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func itemsFor(category: MenuCategory) -> [MenuItem] {
        allItems.filter { $0.category == category.rawValue }
    }

    func loadMenu() async {
        isLoading = true
        // Load from bundled JSON first, then try API
        if let items = loadFromBundle() {
            allItems = items
        }
        isLoading = false
    }

    private func loadFromBundle() -> [MenuItem]? {
        guard let url = Bundle.main.url(forResource: "menu", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let items = try? JSONDecoder().decode([MenuItem].self, from: data) else {
            return nil
        }
        return items
    }
}
