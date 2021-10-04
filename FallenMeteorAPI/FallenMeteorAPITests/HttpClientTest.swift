//
//  HttpClientTest.swift
//  FallenMeteorAPITests
//
//  Created by Shilei Mao on 03/10/2021.
//

import XCTest
@testable import FallenMeteorAPI

class HttpClientTest: XCTestCase {
    var httpClient: HttpClient!
    
    override func setUpWithError() throws {
        httpClient = HttpClient()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMakingRequest() {
        let contentTypeHeaderKey = "Content-type"
        let contentTypeHeaderVal = "Application/json"
        let customHeaderKey = "Custom-header"
        let customHeaderVal = "Custom header value"
        
        
        let queryParamKey1 = "searchText"
        let queryParamVal1 = "hello world"
        let queryParamKey2 = "param2"
        let queryParamVal2 = "value2"
        
        let method = "POST"
        
        let postBody = "Hello world, this is the test post body!".data(using: .utf8)!
        
        let headers = [contentTypeHeaderKey: contentTypeHeaderVal, customHeaderKey: customHeaderVal]
        
        let query = [queryParamKey1: queryParamVal1, queryParamKey2: queryParamVal2]
        
        
        let urlStr = "https://www.google.com"
        
        let request = HttpClient.RequestBuilder(urlStr)
            .method(method)
            .queryParams(query)
            .headers(headers)
            .postBody(postBody)
            .build()
        
        
        XCTAssert(contentTypeHeaderVal == request.urlRequest.value(forHTTPHeaderField: contentTypeHeaderKey), "Failed to test creation url request: header value not match")
        
        XCTAssert(customHeaderVal == request.urlRequest.value(forHTTPHeaderField: customHeaderKey), "Failed to test creation url request: header value not match")
        
        
        let queryPairs = try? request.urlRequest.url?.getQueryParams()
        
        XCTAssert(queryPairs != nil && queryPairs?.count ?? 0 > 0, "Failed to test the query string")
        XCTAssert(queryPairs![queryParamKey1]?.urlDecoded() == queryParamVal1, "Failed to test the query string, value not match")
        XCTAssert(queryPairs![queryParamKey2]?.urlDecoded() == queryParamVal2, "Failed to test the query string, value not match")
        
        XCTAssert(request.urlRequest.httpBody?.count == postBody.count, "Failed test the post body")
        XCTAssert(String(data: request.urlRequest.httpBody!, encoding: .utf8)! == String(data: postBody, encoding: .utf8)!, "Failed to test the post body")
        
    }
    
    func testMakingHttpRequest() {
        let urlStr = "https://www.google.com/search"
        let headers = ["q": "hello world"]
        let request = HttpClient
            .RequestBuilder(urlStr)
            .queryParams(headers)
            .build()
        
        let expectation = expectation(description: "Requesting")
        
        let listener = HttpRequestListener<Data>.init { request in
            print("Request started")
        } finished: { request, data in
            print("Request finished")
            
            guard let data = data, !data.isEmpty else {
                XCTFail("Failed to request data")
                return
            }
            
            expectation.fulfill()
        } error: { request, error in
            print("Request error")
            XCTFail("Failed to request data")
        } canceled: { request in
            print("request cancelled")
            XCTFail("Failed to request data")
        }
        
        request.send({ data in
            return data
        }, listener)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
