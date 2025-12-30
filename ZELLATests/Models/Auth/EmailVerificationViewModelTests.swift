//
//  EmailVerificationViewModelTests.swift
//  ZELLATests
//
//  Created by Panachai Sulsaksakul on 12/30/25.
//

import XCTest
@testable import ZELLA

@MainActor
final class EmailVerificationViewModelTests: XCTestCase {
    // MARK: - Test Properties
    var sut: EmailVerificationViewModel!
    var mockAuthService: MockAuthService!

    let testUID = "test_uid_12345"
    let testEmail = "test@example.com"
    let testName = "Test User"

    // MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        sut = EmailVerificationViewModel(
            uid: testUID,
            email: testEmail,
            name: testName,
            authService: mockAuthService
        )
    }

    override func tearDown() {  
        sut = nil
        mockAuthService = nil
        super.tearDown()
    }

    private func createViewModel(
        uid: String = "test-uid",
        email: String = "test@example.com",
        name: String = "Test"
    ) -> EmailVerificationViewModel {
        return EmailVerificationViewModel(
            uid: uid,
            email: email,
            name: name,
            authService: mockAuthService
        )
    }

    func testInit_SetsPropertiesCorrectly() {
        // Given & When: ViewModel is initialized in setUp()

        // Then: Properties should be set correctly
        XCTAssertEqual(sut.uid, testUID)
        XCTAssertEqual(sut.email, testEmail)
        XCTAssertEqual(sut.name, testName)
        XCTAssertEqual(sut.verificationCode, "")
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertTrue(sut.canResend)
        XCTAssertEqual(sut.resendCooldown, 0)
    }

    // MARK: - confirmCode Validation Tests
    func testConfirmCode_WithEmptyCode_ReturnsFalseAndSetsError() async {
        // Given: Empty verification code
        sut.verificationCode = ""

        // When: Confirming code
        let result = await sut.confirmCode()

        // Then: Should fail with error message
        XCTAssertFalse(result)
        XCTAssertEqual(sut.errorMessage, AppString.emptyVerificationCode)
        XCTAssertFalse(mockAuthService.verifyEmailCodeCalled, "Should not call auth service")
    }

    func testConfirmCode_WithCodeLessThan5Digits_ReturnsFalseAndSetsError() async {
        // Given: Code with only 4 digits
        sut.verificationCode = "1234"

        // When: Confirming code
        let result = await sut.confirmCode()

        // Then: Should fail with error message
        XCTAssertFalse(result)
        XCTAssertEqual(sut.errorMessage, AppString.verificationCodeCheckDigits)
        XCTAssertFalse(mockAuthService.verifyEmailCodeCalled, "Should not call auth service")
    }

    func testConfirmCode_WithCodeMoreThan5Digits_ReturnsFalseAndSetsError() async {
        // Given: Code with 6 digits
        sut.verificationCode = "123456"

        // When: Confirming code
        let result = await sut.confirmCode()

        // Then: Should fail with error message
        XCTAssertFalse(result)
        XCTAssertEqual(sut.errorMessage, AppString.verificationCodeCheckDigits)
        XCTAssertFalse(mockAuthService.verifyEmailCodeCalled, "Should not call auth service")
    }

            func testConfirmCode_WithExactly5Digits_CallsAuthService() async {
        // Given: Valid 5-digit code
        sut.verificationCode = "12345"
        mockAuthService.verifyEmailCodeResult = .success(true)

        // When: Confirming code
        let result = await sut.confirmCode()

        // Then: Should call auth service with correct params
        XCTAssertTrue(result)
        XCTAssertTrue(mockAuthService.verifyEmailCodeCalled)
        XCTAssertEqual(mockAuthService.lastVerifyEmailCodeUID, testUID)
        XCTAssertEqual(mockAuthService.lastVerifyEmailCodeInput, "12345")
    }

    // MARK - confirmCode() Success Tests
    func testConfirmCode_WhenAuthServiceReturnsTrue_ReturnsTrue() async {
        // Given: Valid code and successful auth service
        sut.verificationCode = "12345"
        mockAuthService.verifyEmailCodeResult = .success(true)

        // When: Confirming code
        let result = await sut.confirmCode()

        // Then: Should succeed
        XCTAssertTrue(result)
        XCTAssertNil(sut.errorMessage)
    }

    func testConfirmCode_WhenAuthServiceReturnsFalse_ReturnsFalseWithError() async {
        // Given: Valid code but auth service returns false (invalid code)
        sut.verificationCode = "12345"
        mockAuthService.verifyEmailCodeResult = .success(false)

        // When: Confirming code
        let result = await sut.confirmCode()

        // Then: Should fail with invalid error message
        XCTAssertFalse(result)
        XCTAssertEqual(sut.errorMessage, AppString.invalidVerificationCode)
    }

    // MARK: - confirmCode() Loading State Tests
    func testConfirmCode_SetsLoadingStateCorrectly() async {
        // Given: Valid code with simulated delay
        sut.verificationCode = "12345"
        mockAuthService.simulateDelay = 0.1
        mockAuthService.verifyEmailCodeResult = .success(true)

        // When: Start confirming code
        let task = Task {
            await sut.confirmCode()
        }
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds (50ms)
        XCTAssertTrue(sut.isLoading, "Should be loading during operation")

        // Wait for completion
        _ = await task.value

        // Then: Loading should be false after completion
        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
    }

    func testConfirmCode_ClearsErrorMessageOnSuccess() async {
        // Given: Existing error message
        sut.verificationCode = "12345"
        sut.errorMessage = "Previous error"
        mockAuthService.verifyEmailCodeResult = .success(true)
        
        // When: Confirming code successfully
        _ = await sut.confirmCode()
        
        // Then: Error message should be cleared
        XCTAssertNil(sut.errorMessage)
    }

    // MARK: - confirmCode() Error Handling Tests
    func testConfirmCode_WhenAuthServiceThrows_ReturnsFalseWithError() async {
        // Given: Valid code but auth service throws error
        sut.verificationCode = "12345"
        let testError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Network error"]
        )
        mockAuthService.verifyEmailCodeResult = .failure(testError)
        
        // When: Confirming code
        let result = await sut.confirmCode()
        
        // Then: Should fail with error message
        XCTAssertFalse(result)
        XCTAssertEqual(sut.errorMessage, "Network error")
    }

    // MARK: - resendCode() Tests
    func testResendCode_WhenCannotResend_DoesNotCallAuthService() async {
        // Given: Resend is disabled
        sut.canResend = false

        // When: Attempting to resend
        await sut.resendCode()

        // Then: Should not call auth service
        XCTAssertFalse(mockAuthService.resendVerificationCodeCalled)
    }

    func testResendCode_WhenCanResend_CallsAuthServiceWithCorrectParameters() async {
        // Given: Resend is enalbled
        sut.canResend = true
        mockAuthService.resendVerificationCodeResult = .success(())

        // When: Resending code
        await sut.resendCode()

        // Then: Should call auth service with correct params
        XCTAssertTrue(mockAuthService.resendVerificationCodeCalled)
        XCTAssertEqual(mockAuthService.lastResendUID, testUID)
        XCTAssertEqual(mockAuthService.lastResendEmail, testEmail)
        XCTAssertEqual(mockAuthService.lastResendName, testName)
    }

    func testResendCode_OnSuccess_StartsCooldown() async {
        // Given: Resend is enabled
        sut.canResend = true
        mockAuthService.resendVerificationCodeResult = .success(())

        // When: Resending code
        await sut.resendCode()

        // Then: Cooldown shoud be started
        XCTAssertFalse(sut.canResend, "canResend should be false")
        XCTAssertEqual(sut.resendCooldown, 30, "resendCooldown should be 30")
    }

    func testResendCode_SetsLoadingStateCorrectly() async {}

    func testResendCode_WhenAuthServiceThrows_SetsErrorMessage() async {}

    func testResendCode_ClearsErrorMessageOnStart() async {}

    // MARK: - Cooldown Timer Tests

    // MARK: - cancelSignUp() Tests

    // MARK: - Edge Cases and Integration Tests
}
