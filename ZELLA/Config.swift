//
//  Config.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/6/25.
//

import Foundation

struct Config {
    
    // MARK: - Environment Detection
    
    #if DEBUG
    static let environment = "Development"
    static let isDevelopment = true
    #else
    static let environment = "Production"
    static let isDevelopment = false
    #endif
    
    // MARK: - Stripe Configuration
    
    /// Stripe Publishable Key (safe to include in client app)
    static var stripePublishableKey: String {
        #if DEBUG
        // DEV: Stripe Test Mode Key
        return "pk_test_YOUR_DEV_KEY_HERE"
        #else
        // PROD: Stripe Live Mode Key
        return "pk_live_YOUR_PROD_KEY_HERE"
        #endif
    }
    
    // MARK: - Firebase Cloud Functions
    
    /// Base URL for Firebase Cloud Functions
    static var cloudFunctionBaseURL: String {
        #if DEBUG
        // DEV: zella-dev Cloud Functions
        return "https://asia-southeast1-zella-dev-f446c.cloudfunctions.net"
        #else
        // PROD: zella-prod Cloud Functions
        return "https://asia-southeast1-zella-prod.cloudfunctions.net"
        #endif
    }
    
    // MARK: - Helper Methods
    
    /// Print current environment on app launch (for debugging)
    static func printEnvironment() {
        print("🔧 ZELLA Environment: \(environment)")
        print("🔧 Bundle ID: \(Bundle.main.bundleIdentifier ?? "Unknown")")
        print("🔧 Stripe Key: \(stripePublishableKey.prefix(20))...")
        print("🔧 Functions URL: \(cloudFunctionBaseURL)")
    }
}
