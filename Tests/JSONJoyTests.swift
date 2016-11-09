//
//  JSONJoyTests.swift
//  JSONJoyTests
//
//  Created by Austin Cherry on 9/24/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//

import Foundation
import XCTest
@testable import JSONJoy

import XCTest
@testable import JSONJoy

class JSONJoyTests: XCTestCase {
    
    func testInitAsJSONString() {
        let jsonString = "{\"Key\":\"Value\"}"
        do {
            let decoder = try JSONDecoder(jsonString)
            XCTAssertTrue(try decoder.decoderForKey(key: "Key").getOptionalString() == "Value")
        } catch {
            XCTFail()
        }
    }
    
    func testInitAsJSONData() {
        let jsonData = "{\"Key\":\"Value\"}".data(using: .utf8)
        do {
            let decoder = try JSONDecoder(jsonData)
            XCTAssertTrue(try decoder.decoderForKey(key: "Key").getOptionalString() == "Value")
        } catch {
            XCTFail()
        }
    }
    
    func testGetFromIndexWhenInitializedAsJSON() {
        let jsonData = "{\"Key\":\"Value\"}".data(using: .utf8)
        do {
            let decoder = try JSONDecoder(jsonData)
            XCTAssertThrowsError(try decoder.decoderAtIndex(index: 0))
        } catch {
            XCTFail()
        }
    }
    
    func testInitAsArray() {
        let array: Array<String> = ["A","B","C"]
        do {
            let decoder = try JSONDecoder(array)
            XCTAssertTrue(try decoder.decoderAtIndex(index: 0).getOptionalString() == "A" && decoder.decoderAtIndex(index: 1).getOptionalString() == "B" && decoder.decoderAtIndex(index: 2).getOptionalString() == "C")
        } catch {
            XCTFail()
        }
    }
    
    func testGetFromArrayWithIndexOutOfBounds() {
        let array: Array<String> = ["A","B","C"]
        do {
            let decoder = try JSONDecoder(array)
            XCTAssertThrowsError(try decoder.decoderAtIndex(index: 4))
        } catch {
            XCTFail()
        }
    }
    
    func testGetKeyWhenInitializedAsArray() {
        let array: Array<String> = ["A","B","C"]
        do {
            let decoder = try JSONDecoder(array)
            XCTAssertThrowsError(try decoder.decoderForKey(key: "SomeKey"))
        } catch {
            XCTFail()
        }
    }
    
    func testInitWithDictionary() {
        let dictionary: [String: Any] = ["Key1": "Value1", "Key2": 2]
        do {
            let decoder = try JSONDecoder(dictionary)
            XCTAssertTrue(try decoder.decoderForKey(key: "Key1").getOptionalString() == "Value1" && decoder.decoderForKey(key: "Key2").getOptionalInt() == 2)
        } catch {
            XCTFail()
        }
    }
    
    func testGetValueForNotExistingKey() {
        let dictionary: [String: Any] = ["Key1": "Value1", "Key2": 2]
        do {
            let decoder = try JSONDecoder(dictionary)
            XCTAssertThrowsError(try decoder.decoderForKey(key: "Key3"))
        } catch {
            XCTFail()
        }
    }
    
    func testGetFromIndexWhenInitializedAsDictionary() {
        let dictionary: [String: Any] = ["Key1": "Value1", "Key2": 2]
        do {
            let decoder = try JSONDecoder(dictionary)
            XCTAssertThrowsError(try decoder.decoderAtIndex(index: 0))
        } catch {
            XCTFail()
        }
    }
    
    func testInitWithIncosistentString() {
        let incorrectJSONString = "{ \"abc\": 10"
        XCTAssertThrowsError(try JSONDecoder(incorrectJSONString))
    }
    
    func testInitWithIncosistentData() {
        let incorrectJSONData = "{ \"abc\": 10".data(using: .utf8)
        XCTAssertThrowsError(try JSONDecoder(incorrectJSONData))
    }
    
}
