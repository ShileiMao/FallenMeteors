//
//  FallenMeteorAPITests.swift
//  FallenMeteorAPITests
//
//  Created by Shilei Mao on 03/10/2021.
//

import XCTest
@testable import FallenMeteorAPI

class FallenMeteorAPITests: XCTestCase {
    
    var loader: NetMeteorLoader!
    let requestAPI = "https://data.nasa.gov/resource/gh4g-9sfh.json"
    let appToken = "I0l78V53vIAKQs4Qpwk9sGezs"
    
    override func setUpWithError() throws {
        loader = NetMeteorLoader(apiPath: requestAPI, appToken: appToken)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMeteorFilter() throws {
        var searchFilter = MeteorSearchFilter()
        searchFilter.meteorID = "12232"
        searchFilter.earliestDate = Date.fromString("1900-01-01", format: "yyyy-MM-dd")
        searchFilter.sortBy = "year"
        searchFilter.offset = 0
        
        let expectation1 = expectation(description: "Loading meteors")
        
        var meteorData1: [Meteor] = []
        let listener = HttpRequestListener<[Meteor]>.init { request in
            print("Request started")
        } finished: { request, data in
            print("Request finished")
            meteorData1 = data ?? []
            expectation1.fulfill()
        } error: { request, error in
            print("Request error")
            XCTFail("Failed to get meteor data")
        } canceled: { request in
            print("request cancelled")
            XCTFail("Failed to get meteor data")
        }

        loader.loadMeteors(searchFilter: searchFilter, listener: listener)
        
        let expectation2 = expectation(description: "Loading meteors")
        var meteorData2: [Meteor] = []
        
        let listener2 = HttpRequestListener<[Meteor]>.init { request in
            print("Request started")
        } finished: { request, data in
            print("Request finished")
            meteorData2 = data ?? []
            expectation2.fulfill()
        } error: { request, error in
            print("Request error")
            XCTFail("Failed to get meteor data")
        } canceled: { request in
            print("request cancelled")
            XCTFail("Failed to get meteor data")
        }
        
        
        loader.searchMeteor(with: "12232", listener: listener2)
            
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssert(meteorData1.count == meteorData2.count && !meteorData1.isEmpty, "Failed to filt meteors")
        
        XCTAssert(meteorData1.first!.id == meteorData2.first!.id, "Failed to filt meteors")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
