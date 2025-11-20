//
//  NotificationsView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/17/25.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        VStack {
            Text("Notifications")
                .font(.title)
            Text("Coming soon...")
                .foregroundColor(.secondary)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
}

