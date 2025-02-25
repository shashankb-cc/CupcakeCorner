//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Shashank B on 24/02/25.
//

import SwiftUI

struct ContentView: View {
    @State private var order = Order()
    @State private var savedOrders: [Order] = []

    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(Order.types.indices,id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled)

                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)

                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink("Delivery details") {
                        AddressView(order: $order)
                    }
                }
                
                
            }
            .navigationTitle("Cupcake Corner")
            Section("My Orders") {
                List(savedOrders) { order in
                    VStack(alignment: .leading) {
                        Text("\(order.quantity)x \(Order.types[order.type]) cupcakes")
                            .font(.headline)
                        Text("Deliver to: \(order.name), \(order.streetAddress), \(order.city), \(order.zip)")
                            .font(.subheadline)
                    }
                }
                .onAppear(perform: loadOrdersFromUserDefaults)
            }
        }
    }
    func loadOrdersFromUserDefaults() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "MyOrders"),
           let decoded = try? JSONDecoder().decode([Order].self, from: data) {
            savedOrders = decoded
        }
    }
}

#Preview {
    ContentView()
}
