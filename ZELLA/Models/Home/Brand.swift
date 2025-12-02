//
//  Brand.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/2/25.
//

import Foundation

struct Brand: Identifiable, Codable {
    let id: String
    let name: String
    let logoURL: String?
    
    // Mock data using local assets
    var localImageName: String?
}

struct Store: Identifiable, Codable {
    let id: String
    let name: String
    let bannerURL: String?
    let sellerID: String
    
    // Mock data using local assets
    var localImageName: String?
}
