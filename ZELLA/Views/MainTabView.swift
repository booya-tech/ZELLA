//
//  MainTabView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // MARK: 1. Home
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            // MARK: 2. Swipe
            SwipeView()
                .tabItem {
                    Label("Swipe", systemImage: "flame.fill")
                }
            
            // MARK: 3. Sell
            SellView()
                .tabItem {
                    Label("Sell", systemImage: "plus.circle.fill")
                }
            
            // MARK: 4. Chat
            ChatListView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
            
            // MARK: 5. Profile
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        // Thai market brand color (adjust to your brand)
        .tint(Color(red: 0.1, green: 0.4, blue: 0.8))
    }
}

#Preview {
    MainTabView()
}
