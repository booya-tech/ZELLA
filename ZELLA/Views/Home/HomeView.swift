//
//  HomeView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                
                Text("Home View")
                    .font(.title)
                
                Text("Phase 4: Search & Filter Feed")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("ZELLA")
        }
    }
}

#Preview {
    HomeView()
}
