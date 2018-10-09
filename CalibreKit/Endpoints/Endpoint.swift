//
//  Endpoint.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/7/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Alamofire
import Foundation

public protocol Endpoint {
    associatedtype ParsedResponse: ResponseObjectSerializable
    
    var absoluteURL: URL { get }
    var method: HTTPMethod { get }
    var relativePath: String { get }
    var responseType: ParsedResponse.Type { get }
    
    func hitService(completion: @escaping (DataResponse<ParsedResponse>) -> Void)
}

public extension Endpoint {
    public var absoluteURL: URL {
        // swiftlint:disable:next force_unwrapping
        return URL(string: relativePath, relativeTo: CalibreKitConfiguration.baseURL)!
    }
    
    public var responseType: ParsedResponse.Type {
        return ParsedResponse.self
    }
    
    public func hitService(completion: @escaping (DataResponse<ParsedResponse>) -> Void) {
        request(absoluteURL, method: method, parameters: nil).responseCalibre(completionHandler: completion)
    }
}
