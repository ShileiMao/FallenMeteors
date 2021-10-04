//
//  Meteor.swift
//  FallenMeteorAPI
//
//  Created by Shilei Mao on 03/10/2021.
//

import Foundation
import UIKit

public struct Address: Codable {
    var address: String?
    var city: String?
    var state: String?
    var zip: String?
}

public struct GeoLocation: Codable {
    public var latitude: String?
    public var longitude: String?
    public var human_address: Address?
    
    public func getLatitudeDouble() -> Double? {
        if let latitude = latitude, let doubleValue = getDoubleValue(latitude) {
            return doubleValue
        }
        return nil
    }
    
    public func getLongitudeDouble() -> Double? {
        if let longitude = longitude, let doubleValue = getDoubleValue(longitude) {
            return doubleValue
        }
        return nil
    }
    
    func getDoubleValue(_ string: String) -> Double? {
        if let doubleValue = Double(string) {
            return doubleValue
        }
        return nil
    }
}

/// Struct object that describs a meteor from NASA website
public struct Meteor: Codable, Identifiable {
    public init(name: String, id: String, year: String, mass: String) {
        self.name = name
        self.id = id
        self.year = year
        self.mass = mass
    }
    
    public var name: String?
    public var id: String?
    public var nametype: String?
    public var recclass: String?
    public var mass: String?
    public var fall: String?
    public var year: String?
    public var reclat: String?
    public var reclong: String?
    public var geolocation: GeoLocation?
//    var @computed_region_cbhk_fwbd: String?
//            ":@computed_region_nnqa_25f4": "1391"
}
