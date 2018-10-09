//
//  BooksEndpoint.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/8/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Alamofire
import Foundation

public struct BooksEndpoint: Endpoint {
    public typealias ParsedResponse = [Book]
    public let method: HTTPMethod = .get
    public let relativePath = "/ajax/books/"
    
    public init() {}
    
    public func transform(responseData: Data) throws -> [Book] {
        let booksRawJSON = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
        guard let booksJSON = booksRawJSON as? [String: [String: Any]] else {
            throw CalibreError.message("Unexpected response type: \(type(of: booksRawJSON))")
        }
        
        let booksData: [Data] = try booksJSON.values.map { bookJSON in
            assert(bookJSON.keys.count == 28)
            return try JSONSerialization.data(withJSONObject: bookJSON, options: .prettyPrinted)
        }
        let books = try booksData.map { try JSONDecoder().decode(Book.self, from: $0) }
        return books
    }
}
