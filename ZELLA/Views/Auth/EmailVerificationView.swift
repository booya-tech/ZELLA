//
//  EmailVerificationView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import SwiftUI

struct EmailVerificationView: View {
    let uid: String
    let email: String
    let name: String

    @State private var viewModel: EmailVerificationViewModel
    @Environment(\.dismiss) private var dismiss

    init(uid: String, email: String, name: String) {
        self.uid = uid
        self.email = email
        self.name = name
        _viewModel = State(
            initialValue: EmailVerificationViewModel(uid: uid, email: email, name: name))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            header
            emailDisplay
            verificationField
            timerAndResend
            confirmButton
            Spacer()
        }
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
        .alert(AppString.errorTitle, isPresented: .constant(viewModel.errorMessage != nil)) {
            Button(AppString.ok) { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    // MARK: - UI Components
    private var header: some View {
        VStack(alignment: .leading) {
            Text(AppString.confirmEmailTitle)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            Text(AppString.verificationSent)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }
    
    private var emailDisplay: some View {
        Text(email)
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.top, 20)
    }
    
    private var verificationField: some View {
        // Review here
        DSTextField(
            placeholder: AppString.verificationCodePlaceholder,
            text: $viewModel.verificationCode,
            keyboardType: .numberPad,
            textContentType: .oneTimeCode
        )
    }
    
    private var timerAndResend: some View {
        // Review here
        HStack {
            Text(AppString.verificationValid)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            if viewModel.canResend {
                DSResendButton(
                    title: AppString.resendCode,
                    action: {
                        Task {
                            await viewModel.resendCode()
                        }
                    }
                )
            } else {
                Text("Resend in \(viewModel.resendCooldown)s")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
            }
        }
        .padding(.top, 8)
    }
    
    private var confirmButton: some View {
        DSPrimaryButton(
            title: AppString.confirm,
            action: {
                Task {
                    let success = await viewModel.confirmCode()
                    if success {
                        // AuthService will update isAuthenticated
                        // ContentRouter in ZELLAApp will automatically show MainTabView
                        // We can dismiss this view to clean up navigation stack
                        dismiss()
                    }
                }
            },
            isLoading: viewModel.isLoading
        )
        .padding(.top, 28)
    }
}

#Preview {
    NavigationStack {
        EmailVerificationView(
            uid: "preview-uid",
            email: "user@gmail.com",
            name: "Test User"
        )
    }
}
