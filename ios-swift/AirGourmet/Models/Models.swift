import Foundation

// MARK: - Menu Models

struct MenuItem: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let category: String
    let imageUrl: String?
    let featured: Bool
    let customizationOptions: [CustomizationOption]

    enum CodingKeys: String, CodingKey {
        case id, name, description, category, imageUrl, featured, customizationOptions
    }
}

struct CustomizationOption: Codable, Hashable {
    let name: String
    let priceAdjustment: Double
}

enum MenuCategory: String, CaseIterable, Identifiable {
    case breakfast = "Breakfast"
    case displayTrays = "Display Trays"
    case appetizers = "Appetizers"
    case soups = "Soups"
    case salads = "Salads"
    case sandwiches = "Sandwiches"
    case entrees = "Entrées"
    case desserts = "Desserts"

    var id: String { rawValue }

    var imageName: String {
        switch self {
        case .breakfast: return "menu-breakfast"
        case .displayTrays: return "menu-display-trays"
        case .appetizers: return "menu-appetizers"
        case .soups: return "menu-soups"
        case .salads: return "menu-salads"
        case .sandwiches: return "menu-sandwiches"
        case .entrees: return "menu-entrees"
        case .desserts: return "menu-desserts"
        }
    }
}

// MARK: - Cart Models

struct CartItem: Identifiable, Codable {
    let id: UUID
    let menuItem: MenuItem
    var quantity: Int
    var specialInstructions: String?
    var customizations: [String]

    init(menuItem: MenuItem, quantity: Int = 1, specialInstructions: String? = nil, customizations: [String] = []) {
        self.id = UUID()
        self.menuItem = menuItem
        self.quantity = quantity
        self.specialInstructions = specialInstructions
        self.customizations = customizations
    }
}

// MARK: - User Models

struct User: Codable, Identifiable {
    let id: Int
    let username: String
    let fullName: String
    let email: String
    let phoneNumber: String?
    let companyName: String?
    let isAdmin: Bool
    let aircraftType: String?
}

// MARK: - Order Models

struct DeliveryInfo: Codable {
    var deliveryDate: String
    var deliveryTime: String
    var fbo: String
    var tailNumber: String
    var airportCode: String
    var recipientName: String
    var recipientPhone: String
    var specialInstructions: String?
}

struct Order: Identifiable, Codable {
    let id: Int
    let userId: Int
    let orderDate: String
    let status: String
    let deliveryInfo: DeliveryInfo
    let items: [CartItem]
}

// MARK: - Auth Models

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct RegisterRequest: Codable {
    let username: String
    let password: String
    let fullName: String
    let email: String
    let phoneNumber: String?
    let companyName: String?
}

struct AuthResponse: Codable {
    let user: User
}
