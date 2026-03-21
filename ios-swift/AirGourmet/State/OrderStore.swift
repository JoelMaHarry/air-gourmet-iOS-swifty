import SwiftUI

@MainActor
class OrderStore: ObservableObject {
    @Published var orders: [Order] = []
    @Published var currentOrder: Order?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func submitOrder(items: [CartItem], deliveryInfo: DeliveryInfo) async -> Order? {
        isLoading = true
        errorMessage = nil
        do {
            let order = try await APIClient.shared.submitOrder(items: items, deliveryInfo: deliveryInfo)
            orders.insert(order, at: 0)
            currentOrder = order
            isLoading = false
            return order
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return nil
        }
    }

    func loadOrderHistory() async {
        isLoading = true
        do {
            orders = try await APIClient.shared.getOrderHistory()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
