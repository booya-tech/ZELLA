//
//  DSTextField.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 11/8/25.
//

import SwiftUI

struct DSTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
}
