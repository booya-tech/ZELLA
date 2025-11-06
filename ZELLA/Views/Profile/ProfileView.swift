//
//  ProfileView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                
                Text("Profile")
                    .font(.title)
                
                Text("Phase 2: Your profile, My Sizes, and seller dashboard")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
