//
//  Chatroom.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//

import Foundation
import FirebaseFirestore

/// Represents a chatroom document in the `chatrooms` collection
struct Chatroom: Identifiable, Codable {
    @DocumentID var id: String?
    let buyerID: String
    let sellerID: String
    let itemID: String
    
    // Used for Firestore security rules & queries
    let participants: [String]
    
    // Denormalized data for easy chat list UI
    var lastMessage: String?
    var lastMessageTimestamp: Timestamp?
    var itemTitle: String
    var itemImageURL: String
}
