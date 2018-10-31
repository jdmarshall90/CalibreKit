//
//  BookEndpoint.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/30/18.
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
//  along with Libreca.  If not, see <https://www.gnu.org/licenses/>.
//
//  Copyright © 2018 Justin Marshall
//  This file is part of project: CalibreKit
//

import Alamofire

public struct BookEndpoint: Endpoint, ResponseSerializable {
    private struct BookIDParameterEncoding: ParameterEncoding {
        internal func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            var urlRequest = try urlRequest.asURLRequest()
            
            guard let parameters = parameters else { return urlRequest }
            
            guard let absoluteURL = urlRequest.url?.absoluteString else {
                throw AFError.parameterEncodingFailed(reason: .missingURL)
            }
            
            if let firstParameterKey = parameters.values.first as? Int {
                urlRequest.url = URL(string: absoluteURL + "\(firstParameterKey)")
            }
            
            return urlRequest
        }
    }
    
    public typealias ParsedResponse = Book
    
    public var method: HTTPMethod {
        return .get
    }
    
    public let relativePath = "/ajax/book/"
    
    public var encoding: ParameterEncoding {
        return BookIDParameterEncoding()
    }
    
    public var parameters: Parameters? {
        return ["id": id]
    }
    
    // swiftlint:disable:next identifier_name
    public let id: Int
    
    // swiftlint:disable:next identifier_name
    public init(id: Int) {
        self.id = id
    }
    
    public init(from decoder: Decoder) throws {
        self.id = try decoder.singleValueContainer().decode(Int.self)
    }
}
