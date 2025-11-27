//
//  SizesService.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/26/25.
//

import Foundation
import FirebaseFirestore

class SizesService {
    private var db: Firestore {
        Firestore.firestore()
    }
    
    // MARK: - User Sizes Management
    /// Fetches user size preferences from Firestore
    /// - Parameter uid: The user's unique identifier
    /// - Returns: UserSizes object if it exists, nil otherwise
    func fetchUserSizes(uid: String) async throws -> UserSizes? {
        let sizesRef = db.collection("users").document(uid)
            .collection("privateInfo").document("sizes")

        let snapshot = try await sizesRef.getDocument()

        guard snapshot.exists else {
            Logger.log("ℹ️ No size preferences found for user: \(uid)")
            return nil
        }

        do {
            let sizes = try snapshot.data(as: UserSizes.self)
            Logger.log("🟢 User sizes loaded successfully")
            return sizes
        } catch {
            Logger.log("🔴 Error decoding user sizes: \(error.localizedDescription)")
            throw error
        }
    }

    /// Updates or creates user size preferences in Firestore
    /// - Parameters:
    ///   - uid: The user's unique identifier
    ///   - sizes: The UserSizes object to save
    func updateUserSizes(uid: String, sizes: UserSizes) async throws {
        let sizesRef = db.collection("users").document(uid)
            .collection("privateInfo").document("sizes")

        do {
            try sizesRef.setData(from: sizes, merge: true)
            Logger.log("🟢 User sizes saved successfully")
        } catch {
            Logger.log("🔴 Error saving user sizes: \(error.localizedDescription)")
            throw error
        }
    }
}
