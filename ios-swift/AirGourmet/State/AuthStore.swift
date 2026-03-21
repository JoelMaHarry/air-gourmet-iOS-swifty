import SwiftUI

@MainActor
class AuthStore: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    var isLoggedIn: Bool { currentUser != nil }

    func login(username: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let user = try await APIClient.shared.login(username: username, password: password)
            currentUser = user
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func register(request: RegisterRequest) async {
        isLoading = true
        errorMessage = nil
        do {
            let user = try await APIClient.shared.register(request: request)
            currentUser = user
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func logout() {
        currentUser = nil
    }
}
