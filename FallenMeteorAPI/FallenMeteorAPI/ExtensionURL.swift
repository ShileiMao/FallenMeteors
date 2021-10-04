//
//  ExtensionURL.swift
//  FallenMeteorAPI
//
//  Created by Shilei Mao on 03/10/2021.
//

import Foundation

extension URL {
    /// Get query parameters dictionary from an URL object
    /// - Returns: A dictionary with all the query parameters inside this URL
    func getQueryParams() throws -> [String: String]? {
        let queryParams = try self.query?
            .urlDecoded()?
            .split(separator: "&")
            .reduce(into: [String: String](), { partialResult, item in
                let splited = item.split(separator: "=")
                if splited.count != 2 {
                    throw FallenMeterError.unexpectedParam
                }
                partialResult[String(splited[0]).trimmingCharacters(in: .whitespacesAndNewlines)] = String(splited[1].trimmingCharacters(in: .whitespacesAndNewlines))
            })
        
        return queryParams
    }
}
