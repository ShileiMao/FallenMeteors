//
//  TestDatabase.swift
//  FallenMeteorsTests
//
//  Created by Shilei Mao on 04/10/2021.
//

import XCTest
@testable import FallenMeteors

class TestDatabase: XCTestCase {
    var persistentContainer: PersistenceController!
    
    override func setUpWithError() throws {
        persistentContainer = PersistenceController(inMemory: true)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDataInsert() {
        let viewContext = persistentContainer.container.viewContext
        let meteor1 = FavouriteMeteor(context: viewContext)
        
        meteor1.name = "Meteor1"
        meteor1.id = "1234"
        meteor1.mass = "102"
    
        expectation(forNotification: .NSManagedObjectContextDidSave, object: viewContext) { _ in
            return true
        }
        
        try! viewContext.save()
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Failed to save data")
        }
    }
    
    func testDataFetch() throws {
        testDataInsert()
        
        let viewContext = persistentContainer.container.viewContext
        let fetchRequest = FavouriteMeteor.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", "Meteor1")
        
        let result = try! viewContext.fetch(fetchRequest)
        
        XCTAssert(result.count > 0, "Failed to fetch data")
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
