import SwiftUI

@main
struct AirGourmetApp: App {
    @StateObject private var authStore = AuthStore()
    @StateObject private var cartStore = CartStore()
    @StateObject private var menuStore = MenuStore()
    @StateObject private var orderStore = OrderStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authStore)
                .environmentObject(cartStore)
                .environmentObject(menuStore)
                .environmentObject(orderStore)
        }
    }
}
