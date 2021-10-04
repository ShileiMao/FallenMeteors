//
//  NetMeteorLoader.swift
//  FallenMeteorAPI
//
//  Created by Shilei Mao on 03/10/2021.
//

import Foundation
import CoreLocation
import UIKit

public struct MeteorSearchFilter {
    public init() {
    }
    
    public var meteorName: String?
    public var meteorID: String?
    public var year: Date?
    
    public var pageLimit: Int?
//    var geoLoc: CLLocation?
    
    public var offset: Int?
    
    
    public var sortBy: String?
    
    public var desc: Bool = false
    
    public var earliestDate: Date? = Date.fromString("1900-01-01", format: "yyyy-MM-dd")
    
    public mutating func setOffset(_ newValue: Int) {
        self.offset = newValue
    }
}


public struct NetMeteorLoader {
    let apiPath: String
    let appToken: String?
    
    /// Create Meteor loader helper
    /// - Parameters:
    ///   - apiPath: The NASA api path for requesting the Meteors data
    ///   - appToken: the app token you grabbed from the NASA website, you can specify nil if you don't have one, but the daily allowed requests will be limited
    public init(apiPath: String, appToken: String?) {
        self.apiPath = apiPath
        self.appToken = appToken
    }
    
    private func buildQueries(searchFilter: MeteorSearchFilter) -> [String: String] {
        var queries: [String: String] = [:]
        
        let dateFormat: String = "yyyy-MM-ddTHH:mm:ss.SSS"
        
        if let name = searchFilter.meteorName {
            queries["name"] = name
        }
        
        if let id = searchFilter.meteorID {
            queries["id"] = id
        }
        
        if let year = searchFilter.year, let yearString = year.toString(dateFormat) {
            queries["year"] = yearString
        }
        
        if let pageLimit = searchFilter.pageLimit {
            queries["$limit"] = "\(pageLimit)"
        }
        
        if let offset = searchFilter.offset {
            queries["$offset"] = "\(offset)"
        }
        
        if let sortBy = searchFilter.sortBy {
            queries["$order"] = searchFilter.desc ? "\(sortBy) DESC" : sortBy
        }
            
        if let appToken = self.appToken {
            queries["$$app_token"] = appToken
        }
        
        var whereConditions: [String] = []
        
        if let earliestDate = searchFilter.earliestDate, let yearString = earliestDate.toString(dateFormat) {
            whereConditions.append("year>='\(yearString)'")
        }
        
        if !whereConditions.isEmpty {
            queries["$where"] = whereConditions.joined(separator: " AND ")
        }
        
        return queries
    }
    
    /// Search a JSON list of the meteors from NASA website
    /// - Parameters:
    ///   - searchFilter: An `MeteorSearchFilter` which specified the search conditions
    ///   - listener: The http request listener, you can provide your own listener to do the constom converstion of the data, or handling different HTTP events
    public func loadMeteors(searchFilter: MeteorSearchFilter, listener: HttpRequestListener<[Meteor]>) {
        
        let queries = buildQueries(searchFilter: searchFilter)
        
        let request = HttpClient.RequestBuilder(apiPath)
            .queryParams(queries)
            .build()
        
        request.send({ data in
            do {
                let meteors = try JSONDecoder().decode([Meteor].self, from: data)
                return meteors
            } catch let error {
                print("Error happend when decoding meteor data: \(error)")
            }
            return [Meteor]()
            
        }, listener)
    }
    
    /// Search a meteor with it's ID
    /// - Parameters:
    ///   - ID: id of the meteor
    ///   - listener: The http request listener, you can provide your own listener to do the constom converstion of the data, or handling different HTTP events
    public func searchMeteor(with ID: String, listener: HttpRequestListener<[Meteor]>) {
        var searchFilter = MeteorSearchFilter()
        searchFilter.meteorID = ID
        
        let queries = buildQueries(searchFilter: searchFilter)
        
        let request = HttpClient.RequestBuilder(apiPath)
            .queryParams(queries)
            .build()
        
        request.send({ data in
            do {
                let meteors = try JSONDecoder().decode([Meteor].self, from: data)
                return meteors
            } catch let error {
                print("Error happend when decoding meteor data: \(error)")
            }
            return [Meteor]()
        }, listener)
        
    }
}
