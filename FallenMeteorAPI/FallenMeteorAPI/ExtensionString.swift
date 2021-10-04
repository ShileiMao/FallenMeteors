//
//  ExtensionString.swift
//  FallenMeteorAPI
//
//  Created by Shilei Mao on 03/10/2021.
//

import Foundation

extension String {
//    static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
    
    /// Crete an URL encoded string from self, default escaping characters are `urlHostAllowed`, you can customise your own escaping characters by providing `allowedCharacters` parameter
    /// - Parameter allowedCharacters: escaping characters for the URL encoder
    /// - Returns: URL encoded string
    func urlEncoded(_ allowedCharacters: CharacterSet = .urlHostAllowed) -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)?.replacingOccurrences(of: "+", with: "%2B")
    }
    
    /// Create an URL decoded string from self
    /// - Returns: An URL decoded string
    func urlDecoded() -> String? {
        return self.removingPercentEncoding
    }
}
