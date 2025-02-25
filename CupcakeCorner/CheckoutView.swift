//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Shashank B on 24/02/25.
//

import SwiftUI

struct CheckoutView: View {
    var order:Order
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    var body: some View {
        ScrollView {
            VStack {
//                AsyncImage(url: URL(string: "https://d1wyjpgk9j1ia3.cloudfront.net/default-profile/default-avatar.png"), scale: 1) { image in
//                        image
//                            .resizable()
//                            .scaledToFit()
//                } placeholder: {
//                    ProgressView()
//                }
//                .frame(height: 200)
                Image("CupCake")
                    .resizable()
                    .scaledToFit()
                

                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)

                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
    }
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            
            //save to user defaults
            saveOrderToUserDefaults(order: decodedOrder)

        } catch {
            print("Checkout failed: \(error.localizedDescription)")
        }
    }
    
    func saveOrderToUserDefaults(order: Order) {
        let defaults = UserDefaults.standard
        
        // Fetch existing orders from UserDefaults
        var existingOrders: [Order] = []
        if let data = defaults.data(forKey: "MyOrders"),
           let decoded = try? JSONDecoder().decode([Order].self, from: data) {
            existingOrders = decoded
        }
        
        // Append the new order
        existingOrders.append(order)
        
        // Save updated orders array to UserDefaults
        if let encoded = try? JSONEncoder().encode(existingOrders) {
            defaults.set(encoded, forKey: "MyOrders")
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
