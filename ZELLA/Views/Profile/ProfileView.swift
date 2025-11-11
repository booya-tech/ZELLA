//
//  ProfileView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var authService = AuthService.shared
    @State private var showSignOutAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.black)
                
                Text("Profile")
                    .font(.title)

                // Show user info
                if let user = authService.currentUser {
                    VStack(spacing: 8) {
                        Text("👤 \(user.username)")
                            .font(.headline)

                        Text("📧 Verified: \(user.emailVerified ? "Yes" : "No")")
                            .font(.caption)
                            .foregroundColor(user.emailVerified ? .green : .red)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }

                Text("Phase 2: Your profile, My Sizes, and seller dashboard")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()

                // Sign out Button
                Button {
                    showSignOutAlert = true
                } label: {
                    HStack {
                        Text("Sign Out")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .navigationTitle("Profile")
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    do {
                        try authService.signOut()
                        Logger.log("🟢 Signed out successfully")
                    } catch {
                        Logger.log("🔴 Sign out error: \(error)")
                    }
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}

#Preview {
    ProfileView()
}
