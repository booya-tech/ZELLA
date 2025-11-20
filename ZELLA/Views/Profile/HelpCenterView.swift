//
//  HelpCenterView.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/17/25.
//

import SwiftUI

struct HelpCenterView: View {
    var body: some View {
        VStack {
            Text("Help Center")
                .font(.title)
            Text("Coming soon...")
                .foregroundColor(.secondary)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HelpCenterView()
    }
}

