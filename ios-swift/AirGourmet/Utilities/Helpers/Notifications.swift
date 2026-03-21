import Foundation

struct EmptyResponse: Codable {}

struct EmailNotifications {
    static func sendWelcomeEmail(to user: User) async {
        // Backend handles welcome email on registration
    }

    static func sendOrderConfirmation(order: Order, user: User) async {
        // Backend handles order confirmation email on submission
    }
}
