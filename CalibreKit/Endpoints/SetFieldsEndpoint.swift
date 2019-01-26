//
//  SetFieldsEndpoint.swift
//  CalibreKit
//
//  Created by Justin Marshall on 1/21/19.
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
//  Copyright © 2019 Justin Marshall
//  This file is part of project: CalibreKit
//

import Alamofire

public struct SetFieldsEndpoint: Endpoint {
    public typealias ParsedResponse = [Book]
    public let method: HTTPMethod = .post
    
    public var relativePath: String {
        return "/cdb/set-fields/\(book.id)/"
    }
    
    public enum Change: Hashable {
        public enum Property: Hashable {
            // TODO: Need to figure this one out
            //                "title_sort": nil, // all of these appear to be nillable, but I can't get this field to work ... ? come back to it
            
            // TODO: Need to figure this one out
            //                "author_sort": ["something": "bob"], // can't get this one working? come back to it
            
            // TODO: need to be able to set the cover image
            
            case authors([Book.Author])
            case comments(String?)
            case identifiers([Book.Identifier])
            case languages([Book.Language])
            case publishedDate(Date?)
            case rating(Book.Rating)
            case series(Book.Series?)
            case tags([String])
            case title(Book.Title?)
            
            private static let dateFormatter: ISO8601DateFormatter = {
                let formatter = ISO8601DateFormatter()
                formatter.timeZone = TimeZone.current
                return formatter
            }()
            
            internal var parameters: Parameters? {
                switch self {
                case .authors(let authors):
                    return ["authors": authors.map { $0.name }]
                case .comments(let comments):
                    return ["comments": comments as Any]
                case .identifiers(let identifiers):
                    let identifiersJSON = identifiers.reduce(
                        into: [:], { result, next in
                            result[next.displayValue.lowercased()] = next.uniqueID
                        }
                    )
                    return ["identifiers": identifiersJSON]
                case .languages(let languages):
                    return ["languages": languages.map { $0.displayValue }]
                case .publishedDate(let date):
                    guard let date = date else { return nil }
                    return ["pubdate": Property.dateFormatter.string(from: date)]
                case .rating(let rating):
                    // this seems to actually set this to half of what you send in
                    return ["rating": rating.rawValue * 2]
                case .series(let series):
                    guard let series = series else { return nil }
                    return ["series": series.name, "series_index": series.index]
                case .tags(let tags):
                    return ["tags": tags]
                case .title(let title):
                    return ["title": title?.name as Any]
                }
            }
        }
        
        case noChange
        case change(Set<Property>)
        
        internal var parameters: [Parameters] {
            switch self {
            case .noChange:
                return []
            case .change(let property):
                return property.compactMap { $0.parameters }
            }
        }
    }
    
    public var parameters: Parameters? {
        switch change {
        case .change(let changes):
            let changes = changes.compactMap { $0.parameters }
            
            let flattenedDictionary = changes
                .flatMap { $0 }
                .reduce([String: Any]()) { dict, tuple in
                    var mutableDict = dict
                    mutableDict.updateValue(tuple.1, forKey: tuple.0)
                    return mutableDict
                }
            
            let loadedBookIDs = loadedBooks.map { $0.id }
            
            return [
                "changes": flattenedDictionary,
                "loaded_book_ids": loadedBookIDs
            ]
        case .noChange:
            return nil
        }
    }
    
    public var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    public let book: Book
    public let change: Change
    public let loadedBooks: [Book]
    
    public init(book: Book, change: Change, loadedBooks: [Book] = []) {
        self.book = book
        self.change = change
        self.loadedBooks = loadedBooks
    }
    
    // TODO: Clean up these 2 `transform`s
    public func transform(responseData: Data) throws -> [Book] {
        // swiftlint:disable force_cast
        let json = try JSONSerialization.jsonObject(with: responseData) as! [String: Any]
        let books = try json.keys.map { try transform(bookDictionary: [$0: json[$0] as Any]) }
        return books
    }
    
    private func transform(bookDictionary: [String: Any]) throws -> Book {
        let bookID = Int(bookDictionary.keys.first!)!
        let bookMetadata = bookDictionary.values.first as! [String: Any]
        var modifiedResponseJSON = bookMetadata
        
        // TODO: Use the coding keys directly, stop hardcoding the string keys
        modifiedResponseJSON["application_id"] = bookID
        
        let authors = bookMetadata["authors"] as! [String]
        
        // TODO: Come back to this after you have implemented authorSort being an input to this endpoint
        // comes back as either "Unknown" or array separated by &
        //        let authorSort = bookMetadata["author_sort"] as! String
        //        let authorSortArray = authorSort.split(separator: "&")
        modifiedResponseJSON["author_sort"] = nil
        modifiedResponseJSON["author_sort_map"] = Dictionary(uniqueKeysWithValues: zip(authors, authors))
        
        modifiedResponseJSON["cover"] = book.cover.relativePath
        modifiedResponseJSON["thumbnail"] = book.thumbnail.relativePath
        
        let titleSort = bookMetadata["sort"]
        // TODO: Make sure this still works after you have implemented titleSort being an input to this endpoint
        modifiedResponseJSON["title_sort"] = titleSort
        
        if let rating = modifiedResponseJSON["rating"] as? Int {
            // Just like changing the rating seems to actually set this to half of what you send in, this
            // particular response is double what the actual rating is.
            modifiedResponseJSON["rating"] = rating / 2
        }
        
        let modifiedResponseData = try JSONSerialization.data(withJSONObject: modifiedResponseJSON)
        let parsedResponse = try JSONDecoder().decode(Book.self, from: modifiedResponseData)
        return parsedResponse
    }
}
