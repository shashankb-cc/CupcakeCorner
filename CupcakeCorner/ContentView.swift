//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Shashank B on 24/02/25.
//

import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    
    var disableForm: Bool {
        username.count < 5 || password.count < 5
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Enter you username", text: $username)
                TextField("Enter your password", text: $password)
            }
            Section {
                Button("Create Account") {
                    print("Creating account")
                }
            }
//            .disabled(username.isEmpty || password.isEmpty)
            .disabled(disableForm)
        }
    }
}

#Preview {
    ContentView()
}
