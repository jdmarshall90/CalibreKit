//
//  BooksEndpoint.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/8/18.
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
