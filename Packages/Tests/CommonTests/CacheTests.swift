import XCTest
@testable import Common

final class CacheTests: XCTestCase {
    // MARK: Misc

    private var key: String!
    private var value: [Int]!
    private var sut: Cache<String, [Int]>!

    // MARK: Life Cycle

    override func setUpWithError() throws {
        key = "foo"
        value = [0]
        sut = Cache()
    }

    override func tearDownWithError() throws {
        key = nil
        value = nil
        sut = nil
    }

    // MARK: Test Case - insert(_:forKey:expiredAt)

    func test_insert_whenExpirationDateIsNone() throws {
        XCTAssertNil(sut.value(forKey: key))

        sut.insert(value, forKey: key, expiredAt: nil)

        XCTAssertEqual(sut.value(forKey: key), value)
    }

    func test_insert_whenExpirationDateIsInFuture() throws {
        XCTAssertNil(sut.value(forKey: key))

        sut.insert(value, forKey: key, expiredAt: Date(timeIntervalSinceNow: 60))

        XCTAssertEqual(sut.value(forKey: key), value)
    }

    func test_insert_whenExpirationDateDidPass() throws {
        XCTAssertNil(sut.value(forKey: key))

        sut.insert(value, forKey: key, expiredAt: Date(timeIntervalSinceNow: -60))

        XCTAssertNil(sut.value(forKey: key))
    }

    func test_insert_whenNewValueIsDifferentFromOldValue() throws {
        sut.insert(value, forKey: key, expiredAt: nil)

        XCTAssertEqual(sut.value(forKey: key), value)

        value = [value[0] + 1]

        sut.insert(value, forKey: key, expiredAt: nil)

        XCTAssertEqual(sut.value(forKey: key), value)
    }

    // MARK: Test Cases - value(forKey:)

    func test_value_whenKeyIsInvalid() throws {
        XCTAssertNil(sut.value(forKey: key))
    }

    // MARK: Test Case - removeValue(forKey:)

    func test_removeValue() {
        sut.insert(value, forKey: key, expiredAt: nil)

        XCTAssertNotNil(sut.value(forKey: key))

        sut.removeValue(forKey: key)

        XCTAssertNil(sut.value(forKey: key))
    }

    // MARK: Test Case - subscript(_:)

    func test_subscript_getter() throws {
        sut.insert(value, forKey: key, expiredAt: nil)

        XCTAssertEqual(sut.value(forKey: key), value)
    }

    func test_subscript_getter_whenKeyIsInvalid() throws {
        XCTAssertNil(sut[key])
    }

    func test_subscript_setter() throws {
        XCTAssertNil(sut[key])

        sut[key] = value

        XCTAssertEqual(sut.value(forKey: key), value)

        value = [value[0] + 1]

        sut[key] = value

        XCTAssertEqual(sut.value(forKey: key), value)
    }

    func test_subscript_setter_whenNewValueIsNone() throws {
        sut.insert(value, forKey: key, expiredAt: nil)

        XCTAssertEqual(sut.value(forKey: key), value)

        sut[key] = nil

        XCTAssertNil(sut.value(forKey: key))
    }
}
