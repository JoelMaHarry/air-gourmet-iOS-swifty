import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case serverError(Int)
    case decodingError(Error)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .networkError(let e): return e.localizedDescription
        case .serverError(let code): return "Server error: \(code)"
        case .decodingError: return "Failed to process response"
        case .unauthorized: return "Please sign in to continue"
        }
    }
}

class APIClient {
    static let shared = APIClient()
    private let baseURL = "https://api.air-gourmet.com"
    private var session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        session = URLSession(configuration: config)
    }

    func login(username: String, password: String) async throws -> User {
        let body = LoginRequest(username: username, password: password)
        return try await post("/api/login", body: body, response: User.self)
    }

    func register(request: RegisterRequest) async throws -> User {
        return try await post("/api/register", body: request, response: User.self)
    }

    func submitOrder(items: [CartItem], deliveryInfo: DeliveryInfo) async throws -> Order {
        struct OrderRequest: Codable {
            let items: [CartItem]
            let deliveryInfo: DeliveryInfo
        }
        let body = OrderRequest(items: items, deliveryInfo: deliveryInfo)
        return try await post("/api/orders", body: body, response: Order.self)
    }

    func getOrderHistory() async throws -> [Order] {
        return try await get("/api/orders", response: [Order].self)
    }

    // MARK: - Helpers

    private func post<Body: Encodable, Response: Decodable>(_ path: String, body: Body, response: Response.Type) async throws -> Response {
        guard let url = URL(string: baseURL + path) else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        return try await execute(request, response: response)
    }

    private func get<Response: Decodable>(_ path: String, response: Response.Type) async throws -> Response {
        guard let url = URL(string: baseURL + path) else { throw APIError.invalidURL }
        let request = URLRequest(url: url)
        return try await execute(request, response: response)
    }

    private func execute<Response: Decodable>(_ request: URLRequest, response: Response.Type) async throws -> Response {
        do {
            let (data, urlResponse) = try await session.data(for: request)
            if let httpResponse = urlResponse as? HTTPURLResponse {
                if httpResponse.statusCode == 401 { throw APIError.unauthorized }
                if httpResponse.statusCode >= 400 { throw APIError.serverError(httpResponse.statusCode) }
            }
            do {
                return try JSONDecoder().decode(Response.self, from: data)
            } catch {
                throw APIError.decodingError(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
