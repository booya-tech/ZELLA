//
//  SellView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//

import SwiftUI

struct SellView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("List an Item")
                    .font(.title)
                
                Text("Phase 2: Upload photos, add details, and list your item")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("List an Item")
        }
    }
}

#Preview {
    SellView()
}
