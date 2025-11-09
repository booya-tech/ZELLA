//
//  EmailSignUpView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import SwiftUI

struct EmailSignUpView: View {
    @State private var viewModel = SignUpViewModel()
    @State private var showVerification = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                header
                formFields
                nextButton
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showVerification) {
            EmailVerificationView(email: viewModel.email)
        }
        .alert(AppString.errorTitle, isPresented: .constant(viewModel.errorMessage != nil)) {
            Button(AppString.ok) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    // MARK: - UI Components
    
    private var header: some View {
        Text(AppString.createAccount)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.top, 20)
    }
    
    private var formFields: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(AppString.emailAddress)
                    .font(.subheadline)
                DSTextField(placeholder: AppString.enterEmail, text: $viewModel.email)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(AppString.name)
                    .font(.subheadline)
                DSTextField(placeholder: AppString.enterName, text: $viewModel.name)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(AppString.password)
                    .font(.subheadline)
                DSTextField(placeholder: AppString.enterPassword, text: $viewModel.password, isSecure: true)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(AppString.confirmPassword)
                    .font(.subheadline)
                DSTextField(placeholder: AppString.reenterPassword, text: $viewModel.confirmPassword, isSecure: true)
            }
        }
        .padding(.horizontal)
    }
    
    private var nextButton: some View {
        DSPrimaryButton(
            title: AppString.next,
            action: { Task {
                if await viewModel.signUp() {
                    showVerification = true
                }
            }},
            isLoading: viewModel.isLoading
        )
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

#Preview {
    NavigationStack {
        EmailSignUpView()
    }
}
