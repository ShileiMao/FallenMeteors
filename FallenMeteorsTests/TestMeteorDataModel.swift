//
//  TestMeteorDataModel.swift
//  FallenMeteorsTests
//
//  Created by Shilei Mao on 04/10/2021.
//

import XCTest
@testable import FallenMeteorAPI
@testable import FallenMeteors

class TestMeteorDataModel: XCTestCase {
    
    var dataModel: MeteorDataModel!

    override func setUpWithError() throws {
        dataModel = MeteorDataModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMeteorLoading() throws {
        let sortBy: String = "year DESC"
        var searchFilter = MeteorSearchFilter()
        searchFilter.sortBy = sortBy
        searchFilter.pageLimit = 100
        
        dataModel.searchMeteors(searchFilter, append: false)
        
        
        let expectation = expectation(description: "Loading meteor data")
        expectation.isInverted = true
        
        let result = XCTWaiter(delegate: self).wait(for: [expectation], timeout: 10)
        switch result {
        case .completed, .timedOut:
            if dataModel.meteors.count == 100 {
                expectation.fulfill()
            } else {
                XCTFail("Failed to load meteor data")
            }
            
            let randomIndex = Int.random(in: 0..<100)
            let meteor = dataModel.meteors[randomIndex]
            
            dataModel.filtMeteors(meteor.name ?? "")
            XCTAssert(!dataModel.filtedMeteors.isEmpty && dataModel.filtedMeteors.contains(where: { meteor.id == $0.id }), "Failed to filt meteors")
            
        default:
            XCTFail("Failed to load data")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
