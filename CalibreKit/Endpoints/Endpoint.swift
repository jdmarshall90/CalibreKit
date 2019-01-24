//
//  Endpoint.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/7/18.
//
//  CalibreKit is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  CalibreKit is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with CalibreKit.  If not, see <https://www.gnu.org/licenses/>.
//
//  Copyright © 2018 Justin Marshall
//  This file is part of project: CalibreKit
//

import Alamofire
import Foundation

public protocol Endpoint {
    associatedtype ParsedResponse: ResponseSerializable
    
    var method: HTTPMethod { get }
    var relativePath: String { get }
    var encoding: ParameterEncoding { get }
    var parameters: Parameters? { get }
    
    func absoluteURL() throws -> URL
    func hitService(completion: @escaping (DataResponse<ParsedResponse>) -> Void)
    func transform(responseData: Data) throws -> ParsedResponse
}

public extension Endpoint {
    public var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public func absoluteURL() throws -> URL {
        guard let baseURL = CalibreKitConfiguration.configuration?.url else {
            throw CalibreError.message("Go into settings and set your Calibre© Content Server configuration")
        }
        // swiftlint:disable:next force_unwrapping
        return URL(string: relativePath, relativeTo: baseURL)!
    }
    
    public func hitService(completion: @escaping (DataResponse<ParsedResponse>) -> Void) {
        do {
            try request(try absoluteURL(), method: method, parameters: parameters, encoding: encoding).responseCalibre(transform: transform, completionHandler: completion)
        } catch {
            completion(DataResponse(request: nil, response: nil, data: nil, result: .failure(error)))
        }
    }
    
    public func transform(responseData: Data) throws -> ParsedResponse {
        let parsedResponse = try JSONDecoder().decode(ParsedResponse.self, from: responseData)
        return parsedResponse
    }
}
