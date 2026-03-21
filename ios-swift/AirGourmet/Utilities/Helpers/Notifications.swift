import Foundation

struct EmailNotifications {
    static func sendWelcomeEmail(to user: User) async {
        // Triggered on signup - sends to user and AG staff
        // Implementation via backend API
        _ = try? await APIClient.shared.post("/api/notifications/welcome", body: ["userId": user.id], response: EmptyResponse.self)
    }

    static func sendOrderConfirmation(order: Order, user: User) async {
        // Triggered on order finalization
        _ = try? await APIClient.shared.post("/api/notifications/order-confirmation", body: ["orderId": order.id], response: EmptyResponse.self)
    }
}

struct EmptyResponse: Codable {}
