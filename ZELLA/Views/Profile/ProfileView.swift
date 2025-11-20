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
    @State private var showSignIn = false
    @State private var showMyProfile = false
    @State private var showMySizes = false
    @State private var showMyOrders = false
    @State private var showMyAddresses = false
    @State private var showNotifications = false
    @State private var showHelpCenter = false


    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    userInfoSection

                    Divider()

                    menuItemsSection

                    Divider()

                    if authService.isAuthenticated {
                        signOutButton
                            .padding(.vertical, 16)
                    }

                    Spacer()
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(
                    placement: .principal,
                    content: {
                        Text(AppString.myAccount)
                            .font(.system(size: 18, weight: .semibold))
                    })
                ToolbarItem(
                    placement: .navigationBarTrailing,
                    content: {
                        Image(systemName: "bag")
                            .foregroundStyle(.black)
                    })
            }
            .fullScreenCover(isPresented: $showSignIn) {
                SignInView()
            }
            .navigationDestination(isPresented: $showMyProfile) {
                MyProfileView()
            }
            .navigationDestination(isPresented: $showMySizes) {
                MySizesView()
            }
            .navigationDestination(isPresented: $showMyOrders) {
                MyOrdersView()
            }
            .navigationDestination(isPresented: $showMyAddresses) {
                MyAddressesView()
            }
            .navigationDestination(isPresented: $showNotifications) {
                NotificationsView()
            }
            .navigationDestination(isPresented: $showHelpCenter) {
                HelpCenterView()
            }
            .alert(AppString.signOut, isPresented: $showSignOutAlert) {
                Button(AppString.cancel, role: .cancel) {}
                Button(AppString.signOut, role: .destructive) {
                    Task {
                        do {
                            try authService.signOut()
                            Logger.log("🟢 Signed out successfully")
                        } catch {
                            Logger.log("🔴 Sign out error: \(error.localizedDescription)")
                        }
                    }
                }
             } message: {
                Text(AppString.signOutConfirmation)
             }
        }
    }

    // MARK: User Info Section
    private var userInfoSection: some View {
        HStack {
            // Username
            if authService.isAuthenticated, let user = authService.currentUser {
                Text(user.username.uppercased())
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.black)
            } else {
                Button {
                    showSignIn = true
                } label: {
                    Text(AppString.signInOrRegister)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.black)
                }
            }
            Spacer()
            // Profile Image
            Image(systemName: "person.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.black)
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Menu Items Section
    private var menuItemsSection: some View {
        VStack() {
            // My Profile
            ProfileMenuItem(
                title: AppString.myProfile, 
                action: {
                    if authService.isAuthenticated {
                        showMyProfile = true
                    } else {
                        showSignIn = true
                    }
                }
            )

            // My Sizes
            ProfileMenuItem(
                title: AppString.mySizes, 
                action: {
                    if authService.isAuthenticated {
                        showMySizes = true
                    } else {
                        showSignIn = true
                    }
                }
            )
            
            // My Orders
            ProfileMenuItem(
                title: AppString.myOrders, 
                action: {
                    if authService.isAuthenticated {
                        showMyOrders = true
                    } else {
                        showSignIn = true
                    }
                }
            )

            // My Addresses
            ProfileMenuItem(
                title: AppString.myAddresses, 
                action: {
                    if authService.isAuthenticated {
                        showMyAddresses = true
                    } else {
                        showSignIn = true
                    }
                }
            )

            Divider()

            // Notifications
            ProfileMenuItem(
                title: AppString.notifications, 
                action: {
                    if authService.isAuthenticated {
                        showNotifications = true
                    } else {
                        showSignIn = true
                    }
                }
            )

            // Help Center
            ProfileMenuItem(
                title: AppString.helpCenter, 
                action: {
                    if authService.isAuthenticated {
                        showHelpCenter = true
                    } else {
                        showSignIn = true
                    }
                }
            )
        }
    }

    // MARK: - Sign Out Button
    private var signOutButton: some View {
        Button {
            showSignOutAlert = true
        } label: {
            Text(AppString.signOut)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.black)
        }
    }

    // MARK: - Profile Menu Item
    struct ProfileMenuItem: View {
        let title: String
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.black)
                }
                .padding(.vertical, 16)
            }
        }
    }
}

#Preview {
    ProfileView()
}
