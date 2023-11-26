//
//  AppDelegateTests.swift
//  CurrencyConverterTests
//
//  Created by Khoa Le on 26/11/2023.
//

import XCTest
@testable import CurrencyConverter

final class AppDelegateTests: XCTestCase {
    // MARK: Misc

    var application: UIApplication!
    var sut: AppDelegate!

    // MARK: Life Cycle

    override func setUpWithError() throws {
        application = .shared
        sut = AppDelegate()
    }

    override func tearDownWithError() throws {
        application = nil
        sut = nil
    }

    // MARK: Test Cases

    func testExample() throws {
        XCTAssertTrue(sut.application(application, didFinishLaunchingWithOptions: [:]))
    }
}
