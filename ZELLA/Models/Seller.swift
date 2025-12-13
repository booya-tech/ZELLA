//
//  Seller.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/13/25.
//

import Foundation
import FirebaseFirestore

struct Seller: Identifiable, Codable, Hashable {
    // automatically map a Firestore document's unique identifier to a property in a local Swift Codable struct or class
    @DocumentID var id: String?
    let name: String
    let profileImageURL: String?
    var rating: Double
    var isActive: Bool
    var joinedDate: Timestamp

    // Mock data
    var localImageName: String?

    var displayID: String {
        guard let id = id else { return "" }
        return String(id.prefix(6).uppercased())
    }

    var activeStatus: String {
        isActive ? "Active now" : "Last active \(timeAgo)"
    }

    private var timeAgo: String {
        // will calculate from the last seen
        return "6 hours ago"
    }
}