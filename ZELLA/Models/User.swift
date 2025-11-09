//
//  User.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//

import Foundation
import FirebaseFirestore

/// Represents a user document in the 'users' collection
struct User: Identifiable, Codable {
    // manages the firestore document id
    @DocumentID var id: String?
    let username: String
    var profileImageURL: String?
    // use firebase's timestamp
    let joinedDate: Timestamp
    var isVerifiedSeller: Bool = false
    var stripeConnectID: String?
    var emailVerified: Bool = false
    
    // non-codable property for the UI
    var uid: String { id ?? "" }
}

/// Represents the user's size preferences, stored in a sub-collection:
/// 'users/{userID}/privateInfo/sizes'
struct UserSizes: Codable {
    var tops: String?
    // e.g. '32'
    var bottoms: String?
    // e.g. '10'
    var shoes: String?
}
