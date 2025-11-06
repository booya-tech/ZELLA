//
//  FirebaseService.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//
import Foundation
import FirebaseFirestore

/// Singleton service for Firebase configuration and common operations
class FirebaseService {
    static let shared = FirebaseService()
    
    private init() {}
    
    /// Enable Firestore offline persistence for better UX
    func enableOfflinePersistence() {
        let settings = Firestore.firestore().settings
        settings.isPersistenceEnabled = true
        Firestore.firestore().settings = settings
    }
    
    /// Quick reference to Firestore instance
    var db: Firestore {
        return Firestore.firestore()
    }
}
