//
//  Item.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//

import Foundation
import FirebaseFirestore

/// Represents an item document in the `items` collection
struct Item: Identifiable, Codable {
    @DocumentID var id: String?
    let sellerID: String // Links to a User.id
    var title: String
    var price: Double // Store in THB
    var condition: ItemCondition
    var category: ItemCategory
    var brand: String
    var size: String
    var description: String
    var imageURLs: [String]
    var status: ItemStatus
    let postedDate: Timestamp
    
    // Non-codable property for the UI
    var itemID: String { id ?? "" }
    
    var localImageName: String?
}

enum ItemCondition: String, Codable, CaseIterable {
    case newWithTags = "New"
    case likeNew = "Like New"
    case good = "Good"
    case fair = "Fair"
}

enum ItemStatus: String, Codable {
    case available = "available"
    case pending = "pending" // When in checkout process
    case sold = "sold"
}

enum ItemCategory: String, Codable, CaseIterable {
    case all = "All"
    case top = "Tops"
    case pants = "Pants"
    case outerewear = "Outerwear"
    case dresses = "Dresses & Skirts"
    case accessories = "Accessories"
    case bags = "Bags"
    case shoes = "Shoes"
    
    var displayName: String { rawValue }
}
