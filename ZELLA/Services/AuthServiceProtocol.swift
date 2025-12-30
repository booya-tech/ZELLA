//
//  AuthServiceProtocol.swift
//  ZELLA
//
//  Created by Panachai Sulsaksakul on 12/30/25.
//

import Foundation
import FirebaseFirestore

protocol AuthServiceProtocol {
    func verifyEmailCode(uid: String, inputCode: String) async throws -> Bool

    func resendVerificationCode(uid: String, email: String, name: String) async throws

    func deleteAccount(uid: String) async throws
}

extension AuthService: AuthServiceProtocol {}
