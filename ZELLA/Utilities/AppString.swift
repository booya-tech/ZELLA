//
//  AppString.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import Foundation

enum AppString {
    // MARK: - App Name
    static let appName = "ZELLA"
    static let appTagline = "Thai Fashion Marketplace"
    
    // MARK: - Sign In
    static let username = "Username"
    static let password = "Password"
    static let signIn = "Sign In"
    static let forgotPassword = "Forgot Your Password?"
    static let orDivider = "OR"
    static let signInWithFacebook = "Sign in with Facebook"
    static let signInWithGoogle = "Sign in with Google"
    static let registerWithEmail = "Register with Email"
    
    // MARK: - Sign Up
    static let createAccount = "Create Account"
    static let emailAddress = "Email address"
    static let name = "Name"
    static let confirmPassword = "Confirm Password"
    static let next = "Next"
    
    // MARK: - Verification
    static let confirmEmailTitle = "Confirm Your Email Address"
    static let verificationSent = "we sent the verification code to your email."
    static let verificationCodePlaceholder = "Enter your verification code"
    static let verificationValid = "The verification code is valid for 30 minutes"
    static let resendCode = "Resend code"
    static let confirm = "Confirm"
    
    // MARK: - Placeholders
    static let enterEmail = "Enter your email address"
    static let enterName = "Enter name"
    static let enterPassword = "Enter password"
    static let reenterPassword = "Re-enter password"
    
    // MARK: - Errors
    static let errorTitle = "Error"
    static let signInError = "Sign In Error"
    static let emptyEmailPassword = "Please enter email and password"
    static let emptyEmail = "Please enter your email"
    static let emptyName = "Please enter your name"
    static let passwordTooShort = "Password must be at least 6 characters"
    static let passwordMismatch = "Passwords do not match"
    static let emptyVerificationCode = "Please enter verification code"
    
    // MARK: - Coming Soon
    static let emailSignInComingSoon = "Email sign in not yet implemented"
    static let facebookComingSoon = "Facebook sign in coming soon!"
    static let googleComingSoon = "Google sign in coming soon!"
    static let forgotPasswordComingSoon = "Password reset functionality coming soon!"
    
    // MARK: - Common
    static let ok = "OK"
    static let cancel = "Cancel"
}
