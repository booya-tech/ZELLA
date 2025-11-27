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

// MARK: - Sizing System Enums

/// Represents the sizing system preference
enum SizingSystem: String, Codable, CaseIterable {
    case international = "International"
    case thai = "Thai"
}

/// International top sizes
enum InternationalTopSize: String, Codable, CaseIterable {
    case xxs = "XXS"
    case xs = "XS"
    case s = "S"
    case m = "M"
    case l = "L"
    case xl = "XL"
    case xxl = "XXL"
    case xxxl = "XXXL"
}

/// Thai top sizes (based on Thai fashion standards)
enum ThaiTopSize: String, Codable, CaseIterable {
    case freeSize = "Free Size"
    case xs = "XS (รอบอก 30-32\")"
    case s = "S (รอบอก 32-34\")"
    case m = "M (รอบอก 34-36\")"
    case l = "L (รอบอก 36-38\")"
    case xl = "XL (รอบอก 38-40\")"
    case xxl = "XXL (รอบอก 40-42\")"
}

/// Bottom sizes (waist measurements)
enum BottomSize: String, Codable, CaseIterable {
    case size24 = "24"
    case size25 = "25"
    case size26 = "26"
    case size27 = "27"
    case size28 = "28"
    case size29 = "29"
    case size30 = "30"
    case size31 = "31"
    case size32 = "32"
    case size33 = "33"
    case size34 = "34"
    case size35 = "35"
    case size36 = "36"
    case size38 = "38"
    case size40 = "40"
    case size42 = "42"
    case size44 = "44"
}

/// Shoe sizes (EU sizing with US equivalents)
enum ShoeSize: String, Codable, CaseIterable {
    case eu35 = "EU 35 (US 5)"
    case eu36 = "EU 36 (US 5.5)"
    case eu37 = "EU 37 (US 6.5)"
    case eu38 = "EU 38 (US 7.5)"
    case eu39 = "EU 39 (US 8.5)"
    case eu40 = "EU 40 (US 9)"
    case eu41 = "EU 41 (US 9.5)"
    case eu42 = "EU 42 (US 10.5)"
    case eu43 = "EU 43 (US 11)"
    case eu44 = "EU 44 (US 12)"
    case eu45 = "EU 45 (US 12.5)"
    case eu46 = "EU 46 (US 13)"
}
