//
//  ChatListView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//

import SwiftUI

struct ChatListView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "message.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Messages")
                    .font(.title)
                
                Text("Phase 4: Your conversations with buyers and sellers")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Messages")
        }
    }
}

#Preview {
    ChatListView()
}
