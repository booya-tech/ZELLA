//
//  EmailVerificationView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import SwiftUI

struct EmailVerificationView: View {
    let email: String
    @State private var viewModel = EmailVerificationViewModel()
    
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

            Text(AppString.verificationLink)
                .font(.caption)
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
        DSTextField(
            placeholder: AppString.verificationCodePlaceholder,
            text: $viewModel.verificationCode
        )
    }
    
    private var timerAndResend: some View {
        HStack {
            Text(AppString.verificationValid)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            DSResendButton(
                title: AppString.resendCode) {
                    viewModel.resendCode()
                }
        }
        .padding(.top, 8)
    }
    
    private var confirmButton: some View {
        DSPrimaryButton(
            title: AppString.confirm,
            action: { Task { _ = await viewModel.confirmCode() } },
            isLoading: viewModel.isLoading
        )
        .padding(.top, 28)
    }
}

#Preview {
    NavigationStack {
        EmailVerificationView(email: "user@gmail.com")
    }
}
