//
//  String+ExtensionsTests.swift
//  Skipper
//
//  Created by Denis Kovalev on 09.11.2022.
//

import Foundation
import Skipper
import XCTest

class String_ExtensionsTests: XCTestCase {
    func testFormattedWithMask() {
        XCTAssertEqual("123".formattedWith(mask: ""), "", "Empty mask failed")
        XCTAssertEqual("".formattedWith(mask: " (***) "), "", "Empty string failed")

        XCTAssertEqual("123".formattedWith(mask: "_(***)_"), "_(123)_", "Normal formatting failed")
        XCTAssertEqual("123".formattedWith(mask: "(**)"), "(12)", "Mask less than string failed")
        XCTAssertEqual("12".formattedWith(mask: "(***)"), "(12", "String less than mask failed")

        XCTAssertEqual(
            "123".formattedWith(mask: "_(***)_", maskedCharacter: "_"),
            "1(***)2",
            "Custom replace character failed"
        )
    }

    func testIsValidEmail() {
        XCTAssertTrue("test@winegard.com".isValidEmail())
        XCTAssertTrue("a@a.aa".isValidEmail())
        XCTAssertTrue("a+1@a.aa".isValidEmail())

        XCTAssertFalse("@winegard.com".isValidEmail())
        XCTAssertFalse("a@a.a".isValidEmail())
        XCTAssertFalse("".isValidEmail())
        XCTAssertFalse("a@a.a".isValidEmail())
        XCTAssertFalse("aaaaa".isValidEmail())
        XCTAssertFalse("@.com".isValidEmail())
    }

    func testTrimmed() {
        XCTAssertEqual(" 123 ".trimmed(), "123", "Whitespace trimming failed")
        XCTAssertEqual("\n123\n".trimmed(), "123", "Newline trimming failed")
        XCTAssertEqual("\n 123 \n".trimmed(), "123", "Complex trimming failed")
        XCTAssertEqual("1231".trimmed(characters: "12"), "3", "Custom characters trimming failed")
    }

    func testAbbrevieation() {
        XCTAssertEqual("John Doe".abbreviation(), "JD", "Normal abbreviation failed")
        XCTAssertEqual("John".abbreviation(), "J", "Single word abbreviation failed")
        XCTAssertEqual("".abbreviation(), "", "Empty abbreviation failed")
    }

    func testBase64() {
        XCTAssertEqual("test".toBase64(), "dGVzdA==", "Encoding to base64 failed")
        XCTAssertEqual("dGVzdA==".fromBase64(), "test", "Decoding from base64 failed")
    }
}
