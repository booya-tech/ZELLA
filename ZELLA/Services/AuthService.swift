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
import GoogleSignIn
import FacebookLogin
import FacebookCore
import FirebaseCore

@Observable
class AuthService {
    static let shared = AuthService()

    var currentUser: User? 
    var isAuthenticated: Bool = false
    var currentUserID: String?
    private var currentNonce: String?

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
            if let uid = user?.uid {
                self?.fetchUserData(uid: uid)
            } else {
                self?.currentUser = nil
                self?.isAuthenticated = false
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
                    let user = try snapshot.data(as: User.self)
                    self?.currentUser = user
                    
                    if user.emailVerified {
                        self?.isAuthenticated = true
                        Logger.log("🟢 User data loaded: \(self?.currentUser?.username ?? "")")
                    } else {
                        self?.isAuthenticated = false
                        Logger.log("⚠️ User data loaded: \(user.username) (Unverified)")
                    }
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
        
        // Fetch user data first to check verification status
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
            emailVerified: false
        )

        try db.collection("users").document(result.user.uid).setData(from: newUser)
        Logger.log("🟢 User document created for: \(name)")

        // Generate verification code
        let code = generateVerificationCode()
        try await storeVerificationCode(uid: result.user.uid, code: code)

        // Send verification email
        try await sendVerificationEmail(email: email, code: code, name: name)
        Logger.log("🟢 Verification email sent to: \(email)")

        self.currentUserID = result.user.uid
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
            "name": name
        ]

        do {
            let result = try await sendEmail.call(data)
            Logger.log("🟢 Verification email sent: \(result)")
        } catch {
            Logger.log("🔴 Failed to send email: \(error)")
            throw error
        }
    }

    func verifyEmailCode(uid: String, inputCode: String) async throws -> Bool {
        let verificationRef = db.collection("users").document(uid)
            .collection("verification").document("email")

        let snapshot = try await verificationRef.getDocument()

        guard snapshot.exists else {
            throw NSError(
                domain: "AuthService", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "No verification code found"])
        }

        var verification = try snapshot.data(as: EmailVerification.self)

        // Check if expired
        if verification.isExpired {
            throw NSError(
                domain: "AuthService", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Verification code has expired"])
        }

        // Check if too many attempts
        if verification.hasExceededAttempts {
            throw NSError(
                domain: "AuthService", code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Too many failed attempts. Please request a new code."
                ])
        }

        // Increment attempts
        verification.attempts += 1
        try verificationRef.setData(from: verification)

        // Check if code matches
        if verification.code == inputCode {
            // Mark user as verified
            try await db.collection("users").document(uid).updateData([
                "emailVerified": true
            ])

            // Update local user
            if var user = currentUser {
                user.emailVerified = true
                self.currentUser = user
            }

            self.isAuthenticated = true

            // Delete verification document
            try await verificationRef.delete()

            Logger.log("🟢 Email verified for user: \(uid)")
            return true
        } else {
            Logger.log("🔴 Invalid code. Attempts: \(verification.attempts)")
            return false
        }
    }

    func resendVerificationCode(uid: String, email: String, name: String) async throws {
        let verificationRef = db.collection("users").document(uid)
            .collection("verification").document("email")

        let snapshot = try await verificationRef.getDocument()

        var verification: EmailVerification
        let now = Timestamp(date: Date())

        if snapshot.exists {
            verification = try snapshot.data(as: EmailVerification.self)

            // Check if can resend
            if !verification.canResend() {
                throw NSError(
                    domain: "AuthService", code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Too many resend attempts. Please wait 1 hour."
                    ])
            }

            // Update resend count
            verification.resendCount += 1
            verification.lastResendAt = now
        } else {
            // First time
            verification = EmailVerification(
                code: "",
                createdAt: now,
                expiresAt: now,
                attempts: 0,
                lastResendAt: now,
                resendCount: 1
            )
        }

        // Generate new code
        let newCode = generateVerificationCode()
        verification.code = newCode
        verification.createdAt = now
        verification.expiresAt = Timestamp(date: Date().addingTimeInterval(1800))
        verification.attempts = 0

        // Store new code
        try verificationRef.setData(from: verification)

        // Send email
        try await sendVerificationEmail(email: email, code: newCode, name: name)

        Logger.log("🟢 Verification code resent to: \(email)")
    }

    // MARK: - Sign in with Apple
    func signOut() throws {
        try Auth.auth().signOut()
        currentUser = nil
        isAuthenticated = false
        currentUserID = nil
    }

    func deleteAccount(uid: String) async throws {
        // Delete verification document
        let verificationRef = db.collection("users").document(uid).collection("verification").document("email")
        try await verificationRef.delete()
        Logger.log("🗑️ Verification document deleted")
        
        // Delete user document from Firestore
        try await db.collection("users").document(uid).delete()
        Logger.log("🗑️ User document deleted from Firestore")

        // Delete Firebase Auth account
        guard let currentUser = Auth.auth().currentUser else {
            throw NSError(
                domain: "AuthService", code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "No authenticated user to delete"
                ])
        }

        try await currentUser.delete()
        Logger.log("🗑️ Firebase Auth account deleted")

        // Clear local storage
        self.currentUser = nil
        self.isAuthenticated = false
        self.currentUserID = nil
        Logger.log("🟢 Account deletion complete")
    }

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
                stripeConnectID: nil,
                emailVerified: true
            )

            try userRef.setData(from: newUser)
            self.currentUser = newUser
            Logger.log("🟢 New user created: \(newUser.username)")
        } else {
            fetchUserData(uid: result.user.uid)
        }
    }

    // MARK: - Sign in with Google
    func signInWithGoogle(presentingViewController: UIViewController) async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(
                domain: "AuthService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Missing Google Client ID"]
            )
        }

        // Configure Google Sign-In
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Sign in with Google
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController
        )

        guard let idToken = result.user.idToken?.tokenString else {
            throw NSError(
                domain: "AuthService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Missing Google ID token"]
            )
        }

        let accessToken = result.user.accessToken.tokenString

        // Create Firebase credential
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: accessToken
        )

        // Sign in with Firebase
        let authResult = try await Auth.auth().signIn(with: credential)
        Logger.log("🟢 Firebase sign in successful: \(authResult.user.uid)")

        self.currentUserID = authResult.user.uid

        // Check if this is a new user
        let userRef = db.collection("users").document(authResult.user.uid)
        let userDoc = try await userRef.getDocument()

        if !userDoc.exists {
            // Create new user document
            let username = result.user.profile?.name ?? "User"
            let profileImageURL = result.user.profile?.imageURL(withDimension: 200)?.absoluteString

            let newUser = User(
                id: authResult.user.uid,
                username: username,
                profileImageURL: profileImageURL,
                joinedDate: Timestamp(date: Date()),
                isVerifiedSeller: false,
                stripeConnectID: nil,
                emailVerified: true
            )

            try userRef.setData(from: newUser)
            self.currentUser = newUser
            self.isAuthenticated = true
            Logger.log("🟢 New user created: \(newUser.username)")
        } else {
            fetchUserData(uid: authResult.user.uid)
        }
    }
    
    // MARK: - Sign in with Facebook
    func signInWithFacebook(presentingViewController: UIViewController) async throws {
        // Request Facebook login using continuation to bridge completion handler to async/await
        let loginResult = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<LoginManagerLoginResult, Error>) in
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["public_profile", "email"], from: presentingViewController) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result = result else {
                    continuation.resume(throwing: NSError(
                        domain: "AuthService",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Facebook login was cancelled or failed"]
                    ))
                    return
                }
                
                if result.isCancelled {
                    continuation.resume(throwing: NSError(
                        domain: "AuthService",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Facebook login was cancelled"]
                    ))
                    return
                }
                
                continuation.resume(returning: result)
            }
        }
        
        guard let token = loginResult.token else {
            throw NSError(
                domain: "AuthService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Facebook login was cancelled or failed"]
            )
        }
        
        // Get access token string
        let accessToken = token.tokenString
        
        // Create Firebase credential
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        
        // Sign in with Firebase
        let authResult = try await Auth.auth().signIn(with: credential)
        Logger.log("🟢 Firebase sign in successful: \(authResult.user.uid)")
        
        self.currentUserID = authResult.user.uid
        
        // Get user profile from Facebook Graph API
        var username = "User"
        var profileImageURL: String? = nil
        
        let graphData = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[String: Any]?, Error>) in
            let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id,name,picture.type(large)"])
            graphRequest.start { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: result as? [String: Any])
                }
            }
        }
        
        if let dict = graphData {
            username = dict["name"] as? String ?? "User"
            if let picture = dict["picture"] as? [String: Any],
               let pictureData = picture["data"] as? [String: Any],
               let urlString = pictureData["url"] as? String {
                profileImageURL = urlString
            }
        }
        
        // Check if this is a new user
        let userRef = db.collection("users").document(authResult.user.uid)
        let userDoc = try await userRef.getDocument()
        
        if !userDoc.exists {
            // Create new user document
            let newUser = User(
                id: authResult.user.uid,
                username: username,
                profileImageURL: profileImageURL,
                joinedDate: Timestamp(date: Date()),
                isVerifiedSeller: false,
                stripeConnectID: nil,
                emailVerified: true // Facebook emails are pre-verified
            )
            
            try userRef.setData(from: newUser)
            self.currentUser = newUser
            self.isAuthenticated = true
            Logger.log("🟢 New user created: \(newUser.username)")
        } else {
            fetchUserData(uid: authResult.user.uid)
        }
    }
}
