//
//  BooksResponse.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/8/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Foundation

public struct BooksResponse: ResponseObjectSerializable {
    
    public let books: [Book]
    
    public struct Book: Decodable {
        public let title: String
    }
    
    public init(representation: [String: [String: Any]]) throws {
        let booksJSON = representation.values
        let booksData: [Data] = try booksJSON.map { bookJSON in
            assert(bookJSON.keys.count == 28)
            return try JSONSerialization.data(withJSONObject: bookJSON, options: .prettyPrinted)
        }
        
        self.books = try booksData.map { try JSONDecoder().decode(Book.self, from: $0) }
    }
    
}
