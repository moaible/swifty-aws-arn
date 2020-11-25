import XCTest
@testable import swifty_aws_arn

final class swifty_aws_arnTests: XCTestCase {
    
    func testValidARNValue() {
        do {
            let arn = try ARN("arn:partition:service:region:account-id:resource-id")
            XCTAssertEqual(arn.partition, "partition")
            XCTAssertEqual(arn.service, "service")
            XCTAssertEqual(arn.region, "region")
            XCTAssertEqual(arn.accountID, "account-id")
            XCTAssertEqual(arn.resource, "resource-id")
        } catch {
            XCTFail()
        }
    }
    
    func testEmptyARNValue() {
        let emptyARN = XCTestExpectation(description: "testEmptyARNValue")
        XCTAssertThrowsError(try ARN("")) { error in
            XCTAssertEqual(error as? ARNParseError, ARNParseError.invalidPrefix)
            emptyARN.fulfill()
        }
        XCTWaiter().wait(for: [emptyARN], timeout: 10)
    }
    
    func testInvalidPrefixARNValue() {
        let invalidPrefix = XCTestExpectation(description: "testInvalidPrefixARNValue")
        XCTAssertThrowsError(try ARN("xxx:partition:service:region:account-id:resource-id")) { error in
            XCTAssertEqual(error as? ARNParseError, ARNParseError.invalidPrefix)
            invalidPrefix.fulfill()
        }
        XCTWaiter().wait(for: [invalidPrefix], timeout: 10)
    }
    
    func testInvalidFormatARNValue() {
        let invalidDelimiter = XCTestExpectation(description: "testInvalidFormatARNValue - invalid delimiter")
        XCTAssertThrowsError(try ARN("arn@partition@service@region@account-id@resource-id")) { error in
            XCTAssertEqual(error as? ARNParseError, ARNParseError.invalidPrefix)
            invalidDelimiter.fulfill()
        }
        XCTWaiter().wait(for: [invalidDelimiter], timeout: 10)

        let invalidFormat = XCTestExpectation(description: "testInvalidFormatARNValue - enough section")
        XCTAssertThrowsError(try ARN("arn:partition:service:region:account-id:resource-id:enough")) { error in
            XCTAssertEqual(error as? ARNParseError, ARNParseError.invalidFormat)
            invalidFormat.fulfill()
        }
        XCTWaiter().wait(for: [invalidFormat], timeout: 10)
    }

    static var allTests = [
        ("testEmptyARNValue", testEmptyARNValue),
        ("testInvalidPrefixARNValue", testInvalidPrefixARNValue),
        ("testInvalidFormatARNValue", testInvalidFormatARNValue),
    ]
}
