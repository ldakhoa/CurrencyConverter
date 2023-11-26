//
//  SceneDelegateTests.swift
//  CurrencyConverterTests
//
//  Created by Khoa Le on 26/11/2023.
//

import XCTest
@testable import CurrencyConverter

final class SceneDelegateTests: XCTestCase {
    // MARK: Misc

    private var sut: SceneDelegate!

    // MARK: Life Cycle

    override func setUpWithError() throws {
        sut = SceneDelegate()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}
