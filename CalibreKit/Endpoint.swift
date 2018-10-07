//
//  Endpoint.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/7/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Alamofire
import Foundation

// swiftlint:disable force_unwrapping

internal struct CalibreKitConfiguration {
    internal static var baseURL: URL = URL(string: "http://localhost:8080")!
}

internal typealias CalibreResponse = Decodable

internal extension DataRequest {
    @discardableResult
    internal func responseCalibre<T: CalibreResponse>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data,
                let calibreResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    fatalError("change me")
            }
            
            return .success(calibreResponse)
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

internal protocol Endpoint {
    associatedtype ParsedResponse: CalibreResponse
    
    var absoluteURL: URL { get }
    var method: HTTPMethod { get }
    var relativeURL: URL { get }
    var responseType: ParsedResponse.Type { get }
    
    func hitService(completion: (Result<ParsedResponse>) -> Void)
}

internal extension Endpoint {
    internal var absoluteURL: URL {
        return URL(string: relativeURL.absoluteString, relativeTo: CalibreKitConfiguration.baseURL)!
    }
    
    internal var responseType: ParsedResponse.Type {
        return ParsedResponse.self
    }
    
    internal func hitService(completion: (Result<ParsedResponse>) -> Void) {
        let booksRequest = request(absoluteURL, method: method, parameters: nil)
        booksRequest.responseCalibre { (response: DataResponse<ParsedResponse>) in
            print()
        }
    }
}

internal struct Books: Endpoint {
    
    internal struct Response: CalibreResponse {
        
    }
    
    internal typealias ParsedResponse = Response
    internal let method: HTTPMethod = .get
    internal let relativeURL = URL(string: "/ajax/books/")!
}
