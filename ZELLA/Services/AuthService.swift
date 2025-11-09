//
//  AuthService.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import Observation
import FirebaseFunctions

@Observable
class AuthService {
    static let shared = AuthService()

    var currentUser: User? 
    var isAuthenticated: Bool = false
    var currentUserID: String?

    private var db: Firestore {
        Firestore.firestore()
    }

    private init() {
        // Check if user is already signed in
        if let firebaseUser = Auth.auth().currentUser {
            fetchUserData(uid: firebaseUser.uid)
        }
        // Listen for auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUserID = user?.uid
            self?.isAuthenticated = user != nil
            if let uid = user?.uid {
                self?.fetchUserData(uid: uid)
            } else {
                self?.currentUser = nil
            }
        }
    }

    // MARK: - Fetch user Data
    func fetchUserData(uid: String) {
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            if let error = error {
                Logger.log("🔴 Error fetching user data: \(error)")
                return
            }

            if let snapshot = snapshot, snapshot.exists {
                do {
                    self?.currentUser = try snapshot.data(as: User.self)
                    Logger.log("🟢 User data loaded: \(self?.currentUser?.username ?? "")")
                } catch {
                    Logger.log("🔴 Error decoding user data: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Sign in with Email
    func signInWithEmail(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        self.currentUserID = result.user.uid
        self.isAuthenticated = true
        fetchUserData(uid: result.user.uid)
        Logger.log("🟢 Email sign in successful")
    }

    func signUpWithEmail(email: String, password: String, name: String) async throws {
        // Create auth account
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        Logger.log("🟢 Firebase account created: \(result.user.uid)")

        // Create user document
        let newUser = User(
            id: result.user.uid,
            username: name,
            profileImageURL: nil,
            joinedDate: Timestamp(date: Date()),
            isVerifiedSeller: false,
            stripeConnectID: nil,
            emailVerification: false
        )

        try db.collection("users").document(result.user.uid).setData(from: newUser)
        Logger.log("🟢 User document created for: \(name)")

        // Generate verification code
        let code = generateVerificationCode()
        try await storeVerificationCode(uid: result.user.uid, code: code)

        // Send verification email
        try await result.user.sendEmailVerification()
        Logger.log("🟢 Verification email sent to: \(email)")

        self.currentUserID = result.user.uid
        self.isAuthenticated = true
        self.currentUser = newUser
        Logger.log("🟢 Email sign up successful")
    }

    // MARK: - Email Verification
    func generateVerificationCode() -> String {
        return String(format: "%05d", Int.random(in: 0...99999))
    }

    func storeVerificationCode(uid: String, code: String) async throws {
        let now = Timestamp(date: Date())
        let expiresAt = Timestamp(date: Date().addingTimeInterval(1800))  // 30 minutes

        let verification = EmailVerification(
            code: code,
            createdAt: now,
            expiresAt: expiresAt,
            attempts: 0,
            lastResendAt: nil,
            resendCount: 0
        )

        try db.collection("users").document(uid)
            .collection("verification").document("email")
            .setData(from: verification)

        Logger.log("🟢 Verification code stored for user: \(uid)")
    }

    func sendVerificationEmail(email: String, code: String, name: String) async throws {
        let functions = Functions.functions(region: "asia-southeast1")
        let sendEmail = functions.httpsCallable("sendVerificationEmail")

        let data: [String: Any] = [
            "email": email,
            "code": code,
            "name": name,
        ]

        do {
            let result = try await sendEmail.call(data)
            Logger.log("🟢 Verification email sent: \(result)")
        } catch {
            Logger.log("🔴 Failed to send email: \(error)")
            throw error
        }
    }

    // MARK: - Sign in with Apple
    func signOut() throws {
        try Auth.auth().signOut()
        currentUser = nil
        isAuthenticated = false
        currentUserID = nil
        Logger.log("👋🏻 User signed out")
    }

    private var currentNonce: String?

    func startSignInWithAppleFlow() -> String {
        let nonce = Helpers.randomNonceString()
        currentNonce = nonce
        return Helpers.sha256(nonce)
    }

    func handleSignInWithApple(credential: ASAuthorizationAppleIDCredential) async throws {
        // Get the nonce
        guard let nonce = currentNonce else {
            throw NSError(
                domain: "AuthService", code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Invalid state: A login callback was received, but no login request was sent."
                ])
        }

        // Get the ID token
        guard let appleIDToken = credential.identityToken else {
            throw NSError(
                domain: "AuthService", code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Unable to fetch identity token"
                ])
        }

        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            throw NSError(
                domain: "AuthService", code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Unable to serialize token string from data"
                ])
        }

        // Create a Firebase credential
        let firebaseCredential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: credential.fullName
        )

        // Sign in with Firebase
        let result = try await Auth.auth().signIn(with: firebaseCredential)
        Logger.log("🟢 Firebase sign in successful: \(result.user.uid)")

        // Update auth state immediately
        self.currentUserID = result.user.uid
        self.isAuthenticated = true

        // Check if this is a new user
        let userRef = db.collection("users").document(result.user.uid)
        let userDoc = try await userRef.getDocument()

        if !userDoc.exists {
            // Create a new user document
            var username = "User"
            if let fullName = credential.fullName {
                let firstName = fullName.givenName ?? ""
                let lastName = fullName.familyName ?? ""
                username = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
                if username.isEmpty {
                    username = "User"
                }
            }

            let newUser = User(
                id: result.user.uid,
                username: username,
                profileImageURL: nil,
                joinedDate: Timestamp(date: Date()),
                isVerifiedSeller: false,
                stripeConnectID: nil
            )

            try userRef.setData(from: newUser)
            self.currentUser = newUser
            Logger.log("🟢 New user created: \(newUser.username)")
        } else {
            fetchUserData(uid: result.user.uid)
        }
    }

}
