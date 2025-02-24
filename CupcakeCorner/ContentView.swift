//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Shashank B on 24/02/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    @State private var results = [Result]()
    var body: some View {
        List(results,id: \.trackId) { item in
            VStack(alignment:.leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
             
        }
        AsyncImage(url: URL(string: "https://d1wyjpgk9j1ia3.cloudfront.net/default-profile/default-avatar.png")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Text("There was an error loading the image.")
            } else {
                ProgressView()
            }
        }

    }
    func loadData() async {
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid result")
            return
        }
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self,from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Some error occured",error)
        }
    }
}

#Preview {
    ContentView()
}
