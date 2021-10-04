//
//  HttpRequest.swift
//  FallenMeteorAPI
//
//  Created by Shilei Mao on 03/10/2021.
//

import Foundation
import Combine

public struct HttpRequestListener<T> {
    public init(started: ((_ request: HttpRequest) -> Void)?, finished: ((_ request: HttpRequest, _ data: T?) -> Void)?, error: ((_ request: HttpRequest, _ error: Error) -> Void)?, canceled: ((_ request: HttpRequest) -> Void)?) {
        self.started = started
        self.finished = finished
        self.canceled = canceled
        self.error = error
    }
    
    public var started: ((_ request: HttpRequest) -> Void)?
    
    public var finished: ((_ request: HttpRequest, _ data: T?) -> Void)?
    
    public var error: ((_ request: HttpRequest, _ error: Error) -> Void)?
    
    public var canceled: ((_ request: HttpRequest) -> Void)?
}

public class HttpRequest: NSObject {
    private static let requestQueue = DispatchQueue(label: "HttpRequestQueue")
    
    var urlRequest: URLRequest
    
    var cancellable: AnyCancellable?
    
    public init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
    
    /// Send HTTP request to server, and get notified via `HttpRequestListener`
    public func send<T>(_ convertor: @escaping (_ data: Data) -> T,  _ listener: HttpRequestListener<T>) {
        self.cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                          throw FallenMeterError.httpRequetError("Failed to receive data")
                      }
                
                #if DEBUG
                let string = String(data: data, encoding: .utf8) ?? ""
                print("Server returns string: \n\(string)")
                #endif
                
                return convertor(data)
            })
//            .decode(type: toType, decoder: JSONDecoder())
            .subscribe(on: HttpRequest.requestQueue)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCancel: {
                listener.canceled?(self)
            })
            .sink(receiveCompletion: { completion in
                
                print("Received completion: \(completion)")
                switch completion {
                case .failure(let error):
                    listener.error?(self, error)
                case .finished:
//                    listener.finished(self, nil)
                    print("Finished")
                }
            }, receiveValue: { data in
                //print("Data: \(data)")
                listener.finished?(self, data)
            })
        
    }
    
    
    public func cancel() {
        cancellable?.cancel()
    }
}
