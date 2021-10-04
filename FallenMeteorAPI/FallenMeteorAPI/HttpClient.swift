//
//  HttpClient.swift
//  FallenMeteorAPI
//
//  Created by Shilei Mao on 03/10/2021.
//

import Foundation
import UIKit

public struct HttpClient {
    
    /// Simple helper for building the Http request object
    public class RequestBuilder {
        private var _urlStr: String?
        
        private var _method: String = "GET"
        
        
        private var _queryParams: [String: String]?
        
        
        private var _postBody: Data?
        
        
        private var _headers: [String: String]?
        
        
        /// Create a Builder object with url string
        /// - Parameter requestURL: the target url string that we are going to send request to
        public init(_ requestURL: String) {
            _urlStr = requestURL
        }
        
        /// Change the HTTP method, default is GET
        /// - Parameter value: HTTP method to use for this request
        public func method(_ value: String) -> RequestBuilder {
            _method = value
            return self
        }
        
        /// add the query string to requested URL
        /// - Parameter params: a dictionary of query parameters
        public func queryParams(_ params: [String: String]) -> RequestBuilder {
            _queryParams = params
            return self
        }
        
        
        /// Add post body into the request
        /// - Parameter data: data to be added to the http body
        public func postBody(_ data: Data) -> RequestBuilder {
            _postBody = data
            return self
        }
        
        /// Add custom headers to the http request
        /// - Parameter values: a dictionary for the custom http headers
        public func headers(_ values: [String: String]) -> RequestBuilder {
            _headers = values
            return self
        }
        
        /// Create a HttpRequest object with the configuartion information provided
        /// - Returns: HttpRequest object
        public func build() -> HttpRequest {
            
            guard let urlStr = _urlStr else {
                fatalError("No valid url provided!")
            }
            
            guard let url = createURL(urlStr: urlStr, queryParams: _queryParams) else {
                fatalError("RequestURL not a valid URL string")
            }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = _method
            
            if let headers = _headers {
                headers.forEach { key, value in
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            
            request.httpBody = _postBody
            
            return HttpRequest(urlRequest: request)
        }
        
        
        /// Create URL with the url string and the query parameters
        /// - Parameters:
        ///   - urlStr: the base url string that going to accept the request
        ///   - queryParams: custom query parameters
        /// - Returns: an URL object with the base url string and query parameters formed together
        private func createURL(urlStr: String, queryParams: [String: String]?) -> URL? {
            guard var components = URLComponents(string: urlStr) else {
                return nil
            }
            
            if let queryParams = queryParams, !queryParams.isEmpty {
                let queryComponents = queryParams.map {
                    URLQueryItem(name: $0.key, value: $0.value)
                }
                
                components.queryItems = queryComponents
            }

            return components.url
        }
    }
}
