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
    associatedtype ParsedResponse: ResponseSerializable
    
    var method: HTTPMethod { get }
    var relativePath: String { get }
    
    func absoluteURL() throws -> URL
    func hitService(completion: @escaping (DataResponse<ParsedResponse>) -> Void)
    func transform(responseData: Data) throws -> ParsedResponse
}

public extension Endpoint {
    public func absoluteURL() throws -> URL {
        guard let baseURL = CalibreKitConfiguration.baseURL else {
            throw CalibreError.message("Go into settings and set your Calibre© Content Server URL")
        }
        // swiftlint:disable:next force_unwrapping
        return URL(string: relativePath, relativeTo: baseURL)!
    }
    
    public func hitService(completion: @escaping (DataResponse<ParsedResponse>) -> Void) {
        do {
            try request(try absoluteURL(), method: method, parameters: nil).responseCalibre(transform: transform, completionHandler: completion)
        } catch {
            completion(DataResponse(request: nil, response: nil, data: nil, result: .failure(error)))
        }
    }
    
    public func transform(responseData: Data) throws -> ParsedResponse {
        let parsedResponse = try JSONDecoder().decode(ParsedResponse.self, from: responseData)
        return parsedResponse
    }
}
