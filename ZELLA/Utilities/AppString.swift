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
    static let verificationLink = "Please check your email and click the verification link."
    static let cancelSignup = "Cancel Signup"
    static let cancelSignupTitle = "Cancel Signup?"
    // will change later (cancelSignupMessage)
    static let cancelSignupMessage = "This will delete your account and you can start over."
    static let stay = "Stay"
    
    // MARK: - Placeholders
    static let enterEmail = "Enter your email address"
    static let enterName = "Enter name"
    static let enterPassword = "Enter password"
    static let reEnterPassword = "Re-enter password"
    
    // MARK: - Errors
    static let errorTitle = "Error"
    static let signInError = "Sign In Error"
    static let emptyEmailPassword = "Please enter email and password"
    static let emptyEmail = "Please enter your email"
    static let emptyName = "Please enter your name"
    static let passwordTooShort = "Password must be at least 6 characters"
    static let passwordMismatch = "Passwords do not match"
    static let emptyVerificationCode = "Please enter verification code"
    // Firebase Auth Errors
    static let wrongPassword = "Incorrect password. Please try again."
    static let userNotFound = "No account found with this email."
    static let invalidEmail = "Invalid email address."
    static let userDisabled = "This account has been disabled."
    static let emailAlreadyInUse = "This email is already registered."
    static let weakPassword = "Password is too weak. Use at least 6 characters."
    static let invalidVerificationCode = "Invalid verification code. Please try again."
    static let verificationCodeCheckDigits = "Verification code must be 5 digits"
    static let imageUnavailable = "Image Unavailable"
    
    // MARK: - Coming Soon
    static let emailSignInComingSoon = "Email sign in not yet implemented"
    static let facebookComingSoon = "Facebook sign in coming soon!"
    static let googleComingSoon = "Google sign in coming soon!"
    static let forgotPasswordComingSoon = "Password reset functionality coming soon!"
    
    // MARK: - Profile
    static let myAccount = "MY ACCOUNT"
    static let signInOrRegister = "Sign In or Register"
    static let myProfile = "MY PROFILE"
    static let mySizes = "MY SIZES"
    static let myOrders = "MY ORDERS"
    static let myAddresses = "MY ADDRESSES"
    static let notifications = "NOTIFICATIONS"
    static let helpCenter = "HELP CENTER"
    static let signOut = "SIGN OUT"
    static let signOutConfirmation = "Are you sure you want to sign out?"

    // MARK: - My Sizes
    static let topSize = "Tops"
    static let bottomSize = "Bottoms"
    static let shoeSize = "Shoes"
    static let sizingSystem = "Sizing System"
    static let international = "International"
    static let thai = "Thai"
    static let selectTopSize = "Select top size"
    static let selectBottomSize = "Select bottom size"
    static let selectShoeSize = "Select shoe size"
    static let clear = "Clear"
    static let clearAll = "Clear All"
    static let save = "Save"
    static let sizeRequired = "This field is required"
    static let sizesSavedSuccessfully = "Sizes saved successfully!"
    static let loadingSizes = "Loading your sizes..."
    static let failedToLoadSizes = "Failed to load your sizes"
    static let failedToSaveSizes = "Failed to save sizes"
    static let mustBeSignedIn = "You must be signed in to save sizes"
    static let mySizesDescriptionSectionTitle = "Set your preferred sizes to help sellers find items that fit you perfectly."
    static let sizingSystemSectionTitle = "Sizing System"
    static let mySizesLoadingView = "Loading your sizes..."
    
    // MARK: - Common
    static let ok = "OK"
    static let cancel = "Cancel"
    
    //MARK: - Home
    static let recentlyViewed = "Recently Viewed"
    static let trending = "Trending"
    static let suggestedStore = "Suggested Store"
    static let suggestedBrand = "Suggested Brand"
    static let myFeed = "My Feed"
    static let seeAll = "See All"
    static let loadingMore = "Loading more..."

    // MARK: - Product Description
    static let productDescriptionSectionTitle = "DESCRIPTION:"
    static let productDetailsSectionTitle = "PRODUCT DETAILS:"
    static let productDescriptionSectionSize = "Size"
    static let productDescriptionSectionCategory = "Category"
    static let productDescriptionSectionBrand = "Brand"
    static let productDescriptionSectionCondition = "Condition"
    static let productDescriptionSectionMayAlsoLike = "You may also like"
}
