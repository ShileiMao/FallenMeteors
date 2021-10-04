//
//  TestURLComponents.swift
//  FallenMeteorAPITests
//
//  Created by Shilei Mao on 03/10/2021.
//

import XCTest
@testable import FallenMeteorAPI

class TestURLComponents: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testQueryParams() throws {
        let url1 = URL(string: "https://www.google.com/search?q=helloworld&query2=howareyou")
        let url2 = URL(string: "https://www.google.com/search?q=helloworld&query2=howare%20you")
        let url3 = URL(string: "https://www.google.com/search?q%20=%20helloworld%20&%20query2%20=%20howare%20you")
        let url4 = URL(string: "https://www.google.com/search")
        
        let queries1 = try url1?.getQueryParams()
        let queries2 = try url2?.getQueryParams()
        let queries3 = try url3?.getQueryParams()
        let queries4 = try url4?.getQueryParams()
        
        XCTAssert(queries1?.count == 2 && queries1?["q"] == "helloworld", "Failed to test url query string")
        XCTAssert(queries2?.count == 2 && queries2?["query2"] == "howare you", "Failed to test url query string")
        XCTAssert(queries3?.count == 2 && queries3?["q"] == "helloworld", "Failed to test url query string")
        XCTAssert(queries4 == nil, "Failed to test url query string")
    }
    
    func testQueryString() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let url1 = URL(string: "https://www.google.com/search?q=helloworld&query2=howareyou")!
        let url2 = URL(string: "http://www.google.com/search?q=helloworld&query2=howareyou")!
        let url3 = URL(string: "https:www.google.com/search")!
        let url4 = URL(fileURLWithPath: "file:///var/home/users/myfolder/myflile.txt")
        
        let url5 = URL(string: "http://www.google.com/search?q=helloworld&query2=")!
        
        guard let query1 = try? url1.getQueryParams(), let query2 = try? url2.getQueryParams() else {
            
            XCTFail("Failed to get query params")
            
            return
        }
        
        let query3 = try? url3.getQueryParams()
        let query4 = try? url4.getQueryParams()
        let query5 = try? url5.getQueryParams()
        
        XCTAssert(query1["q"] == "helloworld", "Faield to test the query params, the given parameter not retrieve desired value")
        XCTAssert(query2["query2"] == "howareyou", "Faield to test the query params, the given parameter not retrieve desired value")
        XCTAssert(query3 == nil, "Failed to test the query params, expecte nil")
        XCTAssert(query4 == nil, "Failed to test the query params, expecte nil")
        XCTAssert(query5 == nil, "Failed to test the query params, expecte nil")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
