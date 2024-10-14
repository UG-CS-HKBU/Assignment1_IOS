//
//  ContentView.swift
//  Assignment1_IOS
//
//  Created by Sam Liu on 14/10/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Image(systemName: "house.circle.fill")
                    Text("Home")
                }
            
            HomeView()
                .tabItem {
                    Image(systemName: "calendar.circle.fill")
                    Text("Events")
                }

            HomeView()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Search")
                }

            HomeView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Login")
                }

        }
    }
}

#Preview {
    ContentView()
}
