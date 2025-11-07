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
                    Label("Home", systemImage: "house")
                }
            
            // MARK: 2. Swipe
            SwipeView()
                .tabItem {
                    Label("Swipe", systemImage: "flame")
                }
            
            // MARK: 3. Sell
            SellView()
                .tabItem {
                    Label("Sell", systemImage: "plus.circle")
                }
            
            // MARK: 4. Chat
            ChatListView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
            
            // MARK: 5. Profile
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(.black)
    }
}

#Preview {
    MainTabView()
}
