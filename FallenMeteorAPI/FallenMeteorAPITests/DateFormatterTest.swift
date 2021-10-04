//
//  DateFormatterTest.swift
//  FallenMeteorAPITests
//
//  Created by Shilei Mao on 04/10/2021.
//

import XCTest
@testable import FallenMeteorAPI

class DateFormatterTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDateFormatter() throws {
        let date = Date()
        let randomInterval = Int.random(in: 0..<Int(date.timeIntervalSince1970))
        let randomDate = Date(timeIntervalSinceReferenceDate: TimeInterval(randomInterval))
        
        let formatterStr = "yyyy-MM-dd HH:mm:ss.zzz"
        
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        
        let dateString1 = randomDate.toString(formatterStr)
        let dateString2 = formatter.string(from: randomDate)
        
        
        XCTAssert(dateString1 != nil && dateString1 == dateString2, "Failed to test date format on: \(randomDate)")
    }
    
    func testDateParse() {
        let date = Date()
        let randomInterval = Int.random(in: 0..<Int(date.timeIntervalSince1970))
        let randomDate = Date(timeIntervalSinceReferenceDate: TimeInterval(randomInterval))
        
        let formatterStr = "yyyy-MM-dd HH:mm:ss.zzz"
        
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        
        let dateString = formatter.string(from: randomDate)
        
        let newDate = Date.fromString(dateString, format: formatterStr)
        
        
        XCTAssert(newDate != nil && Int(newDate!.timeIntervalSinceReferenceDate) == randomInterval, "Failed to test date format on: \(randomDate)")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
