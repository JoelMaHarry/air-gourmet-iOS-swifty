import SwiftUI

// MARK: - Delivery Details

struct DeliveryDetailsView: View {
    @EnvironmentObject var cartStore: CartStore
    @EnvironmentObject var orderStore: OrderStore
    @EnvironmentObject var authStore: AuthStore
    @Environment(\.presentationMode) var presentationMode
    @State private var deliveryDate = ""
    @State private var deliveryTime = ""
    @State private var fbo = ""
    @State private var tailNumber = ""
    @State private var airportCode = ""
    @State private var recipientName = ""
    @State private var recipientPhone = ""
    @State private var specialInstructions = ""
    @State private var showOrderSummary = false
    @State private var completedOrder: Order?

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.agBlack)
                        .frame(width: 44, height: 44)
                }
                Spacer()
                Text("DELIVERY DETAILS")
                    .font(.agPageTitle)
                    .foregroundColor(.agBlack)
                    .kerning(1.5)
                Spacer()
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, AGSpacing.md)
            .overlay(Rectangle().frame(height: 1).foregroundColor(Color.agLightGrey), alignment: .bottom)

            ScrollView {
                VStack(spacing: AGSpacing.md) {
                    Group {
                        AGTextField(placeholder: "Delivery Date (MM/DD/YYYY)", text: $deliveryDate)
                        AGTextField(placeholder: "Delivery Time", text: $deliveryTime)
                        AGTextField(placeholder: "FBO", text: $fbo)
                        AGTextField(placeholder: "Tail Number", text: $tailNumber)
                        AGTextField(placeholder: "Airport Code", text: $airportCode)
                        AGTextField(placeholder: "Recipient Name", text: $recipientName)
                        AGTextField(placeholder: "Recipient Phone", text: $recipientPhone)
                    }

                    VStack(alignment: .leading, spacing: AGSpacing.xs) {
                        Text("SPECIAL INSTRUCTIONS")
                            .font(.agButton)
                            .foregroundColor(.agDarkGrey)
                            .kerning(1)
                        TextEditor(text: $specialInstructions)
                            .font(.agBody)
                            .frame(height: 100)
                            .padding(AGSpacing.md)
                            .background(Color.agOffWhite)
                            .cornerRadius(AGRadius.input)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if let error = orderStore.errorMessage {
                        Text(error)
                            .font(.agMenuItemDescription)
                            .foregroundColor(.red)
                    }

                    Button(action: finalizeOrder) {
                        if orderStore.isLoading {
                            ProgressView().tint(.agWhite).agPrimaryButton()
                        } else {
                            Text("FINALIZE ORDER").agPrimaryButton()
                        }
                    }
                    .padding(.bottom, AGSpacing.xxxl)
                }
                .padding(.horizontal, AGSpacing.lg)
                .padding(.top, AGSpacing.lg)
            }
        }
        .background(Color.agWhite)
        .sheet(isPresented: $showOrderSummary) {
            if let order = completedOrder {
                OrderSummaryView(order: order)
            }
        }
    }

    private func finalizeOrder() {
        let info = DeliveryInfo(
            deliveryDate: deliveryDate,
            deliveryTime: deliveryTime,
            fbo: fbo,
            tailNumber: tailNumber,
            airportCode: airportCode,
            recipientName: recipientName,
            recipientPhone: recipientPhone,
            specialInstructions: specialInstructions.isEmpty ? nil : specialInstructions
        )
        Task {
            if let order = await orderStore.submitOrder(items: cartStore.items, deliveryInfo: info) {
                completedOrder = order
                cartStore.clearCart()
                showOrderSummary = true
            }
        }
    }
}

// MARK: - Order Summary

struct OrderSummaryView: View {
    let order: Order
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("ORDER CONFIRMED")
                    .font(.agPageTitle)
                    .foregroundColor(.agBlack)
                    .kerning(1.5)
                Spacer()
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.agBlack)
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, AGSpacing.md)
            .overlay(Rectangle().frame(height: 1).foregroundColor(Color.agLightGrey), alignment: .bottom)

            ScrollView {
                VStack(alignment: .leading, spacing: AGSpacing.xl) {
                    // Confirmation message
                    VStack(spacing: AGSpacing.md) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.agCoral)
                        Text("Your order has been placed!")
                            .font(.agSectionTitle)
                            .foregroundColor(.agBlack)
                            .multilineTextAlignment(.center)
                        Text("A confirmation email has been sent to you.")
                            .font(.agBody)
                            .foregroundColor(.agDarkGrey)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, AGSpacing.xl)

                    // Order number
                    orderDetailRow("Order Number", value: "#\(order.id)")

                    // Delivery info
                    VStack(alignment: .leading, spacing: AGSpacing.md) {
                        Text("DELIVERY DETAILS")
                            .font(.agButton)
                            .foregroundColor(.agDarkGrey)
                            .kerning(1)

                        orderDetailRow("Date", value: order.deliveryInfo.deliveryDate)
                        orderDetailRow("Time", value: order.deliveryInfo.deliveryTime)
                        orderDetailRow("FBO", value: order.deliveryInfo.fbo)
                        orderDetailRow("Tail Number", value: order.deliveryInfo.tailNumber)
                        orderDetailRow("Airport", value: order.deliveryInfo.airportCode)
                        orderDetailRow("Recipient", value: order.deliveryInfo.recipientName)
                    }

                    // Items
                    VStack(alignment: .leading, spacing: AGSpacing.md) {
                        Text("ITEMS ORDERED")
                            .font(.agButton)
                            .foregroundColor(.agDarkGrey)
                            .kerning(1)

                        ForEach(order.items) { item in
                            HStack {
                                Text(item.menuItem.name)
                                    .font(.agBody)
                                    .foregroundColor(.agBlack)
                                Spacer()
                                Text("×\(item.quantity)")
                                    .font(.agBody)
                                    .foregroundColor(.agDarkGrey)
                            }
                        }
                    }

                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("DONE").agPrimaryButton()
                    }
                    .padding(.bottom, AGSpacing.xxxl)
                }
                .padding(.horizontal, AGSpacing.lg)
            }
        }
        .background(Color.agWhite)
    }

    private func orderDetailRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.agMenuItemDescription)
                .foregroundColor(.agDarkGrey)
            Spacer()
            Text(value)
                .font(.agBody)
                .foregroundColor(.agBlack)
        }
    }
}

// MARK: - Order History

struct OrderHistoryView: View {
    @EnvironmentObject var orderStore: OrderStore
    @EnvironmentObject var authStore: AuthStore
    @State private var selectedOrder: Order?

    var body: some View {
        VStack(spacing: 0) {
            Text("ORDER HISTORY")
                .font(.agSectionTitle)
                .foregroundColor(.agBlack)
                .kerning(1.5)
                .padding(.vertical, AGSpacing.xl)

            if orderStore.isLoading {
                Spacer()
                ProgressView().tint(.agCoral)
                Spacer()
            } else if orderStore.orders.isEmpty {
                Spacer()
                Text("No orders yet")
                    .font(.agBody)
                    .foregroundColor(.agMediumGrey)
                Spacer()
            } else {
                List(orderStore.orders) { order in
                    Button(action: { selectedOrder = order }) {
                        HStack {
                            VStack(alignment: .leading, spacing: AGSpacing.xs) {
                                Text("Order #\(order.id)")
                                    .font(.agMenuItemTitle)
                                    .foregroundColor(.agBlack)
                                Text(order.deliveryInfo.deliveryDate)
                                    .font(.agMenuItemDescription)
                                    .foregroundColor(.agDarkGrey)
                                Text(order.status.uppercased())
                                    .font(.agButton)
                                    .foregroundColor(.agCoral)
                                    .kerning(1)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.agMediumGrey)
                        }
                        .padding(.vertical, AGSpacing.xs)
                    }
                }
                .listStyle(.plain)
            }
        }
        .task { await orderStore.loadOrderHistory() }
        .sheet(item: $selectedOrder) { order in
            OrderSummaryView(order: order)
        }
    }
}
