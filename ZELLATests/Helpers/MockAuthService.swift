//
//  MockAuthService.swift
//  ZELLATests
//
//  Created by Panachai Sulsaksakul on 12/30/25.
//

import Foundation
@testable import ZELLA

class MockAuthService: AuthServiceProtocol {
    // Track method calls
    var verifyEmailCodeCalled = false
    var verifyEmailCodeCallCount = 0
    var lastVerifyEmailCodeUID : String?
    var lastVerifyEmailCodeInput: String?

    var resendVerificationCodeCalled = false
    var resendVerificationCodeCallCount = 0
    var lastResendUID: String?
    var lastResendEmail: String?
    var lastResendName: String?

    var deleteAccountCalled = false
    var deleteAccountCallCount = 0
    var lastDeleteAccountUID: String?

    // Configure behavior
    var verifyEmailCodeResult: Result<Bool, Error> = .success(true)
    var resendVerificationCodeResult: Result<Void, Error> = .success(())
    var deleteAccountResult: Result<Void, Error> = .success(())

    // Simulate delay
    var simulateDelay: TimeInterval = 0

    func verifyEmailCode(uid: String, inputCode: String) async throws -> Bool {
        verifyEmailCodeCalled = true
        verifyEmailCodeCallCount += 1
        lastVerifyEmailCodeUID = uid
        lastVerifyEmailCodeInput = inputCode

        if simulateDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(simulateDelay * 1_000_000_000))
        }

        switch verifyEmailCodeResult {
            case .success(let value):
                return value
            case .failure(let error):
                throw error
        }
    }
    
    func resendVerificationCode(uid: String, email: String, name: String) async throws {
        resendVerificationCodeCalled = true
        resendVerificationCodeCallCount += 1
        lastResendUID = uid
        lastResendEmail = email
        lastResendName = name

        if simulateDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(simulateDelay * 1_000_000_000))
        }

        switch resendVerificationCodeResult {
            case .success():
                return
            case .failure(let error):
                throw error
        }   
    }
    
    func deleteAccount(uid: String) async throws {
        deleteAccountCalled = true
        deleteAccountCallCount += 1
        lastDeleteAccountUID = uid

        if simulateDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(simulateDelay * 1_000_000_000))
        }

        switch deleteAccountResult {
            case .success():
                return
            case .failure(let error):
                throw error
        }
    }

    func reset() {
        verifyEmailCodeCalled = false
        verifyEmailCodeCallCount = 0
        lastVerifyEmailCodeUID = nil
        lastVerifyEmailCodeInput = nil

        resendVerificationCodeCalled = false
        resendVerificationCodeCallCount = 0
        lastResendUID = nil
        lastResendEmail = nil
        lastResendName = nil

        deleteAccountCalled = false
        deleteAccountCallCount = 0
        lastDeleteAccountUID = nil

        verifyEmailCodeResult = .success(true)
        resendVerificationCodeResult = .success(())
        deleteAccountResult = .success(())
        simulateDelay = 0
    }
}
