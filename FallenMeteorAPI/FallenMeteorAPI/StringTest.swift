//
//  StringTest.swift
//  FallenMeteorAPITests
//
//  Created by Shilei Mao on 03/10/2021.
//

import XCTest
@testable import FallenMeteorAPI
import SwiftUI

class StringTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURLEncoding() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let sampleEncodings = [
            "Hello world!": "Hello%20world!",
            "HiHowAreYou": "HiHowAreYou",
            "@ He & * # + %": "%40%20He%20%26%20*%20%23%20%2B%20%25",
            "https://www.google.com?helo=hfdasf  hfdasf&fdaf=fdaf": "https%3A%2F%2Fwww.google.com%3Fhelo%3Dhfdasf%20%20hfdasf%26fdaf%3Dfdaf"
        ]
        
        
        var encodedOutput = [String: String]()
        var decodedOutput = [String: String]()
        
        sampleEncodings.forEach { key, value in
            encodedOutput[key] = key.urlEncoded() ?? key
        }
        
        encodedOutput.forEach { key, value in
            decodedOutput[key] = encodedOutput[key]?.urlDecoded() ?? key
        }
        
        sampleEncodings.forEach { key, value in
            let sampleEncoded = sampleEncodings[key]
            let programEncoded = encodedOutput[key]
            let programeDecoded = decodedOutput[key]
            
            XCTAssert(sampleEncoded == programEncoded, "Failed to test url encoding: \(key), program output: \(programEncoded), expected: \(sampleEncoded)")
            XCTAssert(programeDecoded == key, "Failed to test url decoding: \(value), program output: \(programeDecoded), expected: \(key)")
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
