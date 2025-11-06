//
//  ZELLAApp.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/5/25.
//

import SwiftUI
import FirebaseCore

@main
struct ZELLAApp: App {

    init() {
        FirebaseApp.configure()

        Config.printEnvironment()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
