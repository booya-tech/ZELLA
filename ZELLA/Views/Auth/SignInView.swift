//
//  SignInView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @State private var viewModel = SignInViewModel()
    @State private var showEmailSignUp = false
    @State private var showForgotPassword = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    logoHeader
                    emailPasswordSection
                    orDivider
                    socialButtonsSection
                    registerButton
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showEmailSignUp) {
                EmailSignUpView()
            }
            .alert(AppString.signInError, isPresented: .constant(viewModel.errorMessage != nil)) {
                Button(AppString.ok) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .alert(AppString.forgotPassword, isPresented: $showForgotPassword) {
                Button(AppString.ok) { }
            } message: {
                Text(AppString.forgotPasswordComingSoon)
            }
        }
    }
    
    // MARK: - UI Components
    private var logoHeader: some View {
        Text(AppString.appName)
            .font(.system(size: 40, weight: .medium))
            .padding(.top, 40)
            .padding(.bottom, 20)
    }
    
    private var emailPasswordSection: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(AppString.username)
                    .font(.subheadline)
                DSTextField(placeholder: AppString.enterEmail, text: $viewModel.email)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(AppString.password)
                    .font(.subheadline)
                DSTextField(placeholder: AppString.enterPassword, text: $viewModel.password, isSecure: true)
            }
            
            DSPrimaryButton(
                title: AppString.signIn,
                type: .normal,
                action: { Task { _ = await viewModel.signInWithEmail() } },
                isLoading: viewModel.isLoading
            )
            
            HStack {
                Spacer()
                Button {
                    showForgotPassword = true
                } label: {
                    Text(AppString.forgotPassword)
                        .font(.subheadline)
                        .foregroundColor(.black)
                }

            }
        }
        .padding(.horizontal)
    }
    
    private var orDivider: some View {
        DSDivider(text: AppString.orDivider)
            .padding(.horizontal)
            .padding(.vertical, 8)
    }
    
    private var socialButtonsSection: some View {
        VStack(spacing: 16) {
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = viewModel.startAppleSignInFlow()
                },
                onCompletion: { result in
                    Task { await viewModel.handleAppleSignIn(result) }
                }
            )
            .signInWithAppleButtonStyle(.white)
            .frame(height: 40)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(AppColors.textFieldBorder, lineWidth: 0.5)
            )
            
            DSSocialButton(
                title: AppString.signInWithFacebook,
                icon: "facebook-icon",
                iconType: .image,
                action: viewModel.signInWithFacebook
            )
            
            DSSocialButton(
                title: AppString.signInWithGoogle,
                icon: "google-icon",
                iconType: .image,
                action: viewModel.signInWithGoogle
            )
        }
        .padding(.horizontal)
    }
    
    private var registerButton: some View {
        DSTextButton(
            title: AppString.registerWithEmail,
            action: { showEmailSignUp = true }
        )
        .padding(.top, 8)
    }
}

#Preview {
    SignInView()
}
