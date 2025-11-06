//
//  SwipeView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//

import SwiftUI

struct SwipeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "flame.fill")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Swipe View")
                .font(.title)
            
            Text("Phase 4: Tinder-style Swipe Feed")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    SwipeView()
}
