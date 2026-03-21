import SwiftUI

@MainActor
class CartStore: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var isCartVisible = false

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var isEmpty: Bool { items.isEmpty }

    func addItem(_ menuItem: MenuItem, quantity: Int = 1, specialInstructions: String? = nil, customizations: [String] = []) {
        if let index = items.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
            items[index].quantity += quantity
        } else {
            let cartItem = CartItem(menuItem: menuItem, quantity: quantity, specialInstructions: specialInstructions, customizations: customizations)
            items.append(cartItem)
        }
        isCartVisible = true
    }

    func removeItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }

    func updateQuantity(_ item: CartItem, quantity: Int) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            if quantity <= 0 {
                items.remove(at: index)
            } else {
                items[index].quantity = quantity
            }
        }
    }

    func clearCart() {
        items = []
        isCartVisible = false
    }
}
