//
//  WishListView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/18/25.
//

import SwiftUI

struct WishListView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "heart")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Wish List")
                    .font(.title)
                
                Text("Phase 5: This is where user can see their wishlist.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Wish List")
        }
    }
}

#Preview {
    WishListView()
}

