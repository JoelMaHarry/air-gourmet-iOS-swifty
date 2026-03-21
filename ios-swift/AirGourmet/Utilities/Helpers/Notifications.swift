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

// Extend APIClient to allow internal post calls
extension APIClient {
    func post<Body: Encodable, Response: Decodable>(_ path: String, body: Body, response: Response.Type) async throws -> Response {
        guard let url = URL(string: "https://api.air-gourmet.com" + path) else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
