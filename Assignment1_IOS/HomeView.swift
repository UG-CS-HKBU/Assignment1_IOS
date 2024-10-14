//
//  HomeView.swift
//  Assignment1_IOS
//
//  Created by Sam Liu on 14/10/2024.
//

import SwiftUI

struct HomeView: View {
    
    @State private var home: [Homes] = []
    
    var body: some View {
        List(home) { homeItem in
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: homeItem.image)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .frame(height: 200)
                Text(homeItem.title)
                    .font(.headline)
                Text(homeItem.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .onAppear(perform: startLoad)
        .refreshable {
            startLoad()
        }
    }
}

struct Homes: Identifiable, Decodable {
    let id = UUID()  // Automatically generate UUIDs
    let title: String
    let description: String
    let image: String
}

extension HomeView {
    
    func startLoad() {
        let url = URL(string: "https://comp4097-event.azurewebsites.net/api/events?highlight=true")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.handleClientError(error)
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.handleServerError(response)
                }
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let data = data {
                do {
                    let homeItems = try JSONDecoder().decode([Homes].self, from: data)
                    DispatchQueue.main.async {
                        self.home = homeItems
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.handleClientError(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func handleClientError(_ error: Error) {
        // Handle the error by showing a message or a fallback
        self.home = [
            Homes(title: "Error", description: "Failed to load data: \(error.localizedDescription)", image: "")
        ]
    }
        
    func handleServerError(_ response: URLResponse?) {
        // Handle the server error
        self.home = [
            Homes(title: "Error", description: "Server error. Response: \(String(describing: response))", image: "")
        ]
    }
}

#Preview {
    HomeView()
}
