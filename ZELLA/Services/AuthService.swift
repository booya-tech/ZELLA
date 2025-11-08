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

@Observable
class AuthService {
    static let shared = AuthService()

    var currentUser: User? 
    var isAuthenticated: Bool = false
    var currentUserID: String?

    private let db = Firestore.firestore()

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
