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
        case authors([Book.Author])
        case comments(String?)
        case cover(Data?)
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
            case .cover(let coverData):
                return ["cover": coverData?.base64EncodedString() as Any]
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
                return ["pubdate": Change.dateFormatter.string(from: date)]
            case .rating(let rating):
                // this seems to actually set this to half of what you send in
                return ["rating": rating.rawValue * 2]
            case .series(let series):
                guard let series = series else { return nil }
                return ["series": series.name, "series_index": series.index]
            case .tags(let tags):
                return ["tags": tags]
            case .title(let title):
                return [
                    "title": title?.name as Any,
                    "sort": title?.sort as Any
                ]
            }
        }
    }
    
    public var parameters: Parameters? {
        let changes = self.changes.compactMap { $0.parameters }.compactMap { $0 }
        
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
    }
    
    public var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    public let book: Book
    public let changes: Set<Change>
    public let loadedBooks: [Book]
    
    public init(book: Book, changes: Set<Change>, loadedBooks: [Book] = []) {
        self.book = book
        self.changes = changes
        self.loadedBooks = loadedBooks
    }
    
    public func transform(responseData: Data) throws -> [Book] {
        let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any] ?? [:]
        let books = try json.keys.map { try transform(bookDictionary: [$0: json[$0] as Any]) }
        return books
    }
    
    private func transform(bookDictionary: [String: Any]) throws -> Book {
        let bookID = Int(bookDictionary.keys.first ?? "")
        let bookMetadata = bookDictionary.values.first as? [String: Any] ?? [:]
        var modifiedResponseJSON = bookMetadata
        
        modifiedResponseJSON[Book.CodingKeys.id.rawValue] = bookID
        
        let authors = bookMetadata[Book.CodingKeys.authors.rawValue] as? [String] ?? []
        
        let authorSort = bookMetadata["author_sort"] as? String
        // comes back as either "Unknown" or array separated by &
        let authorSortArray = authorSort?.split(separator: "&").map { $0.trimmingCharacters(in: .whitespaces) } ?? []
        
        modifiedResponseJSON["author_sort"] = nil
        modifiedResponseJSON[Book.CodingKeys.authorSortMap.rawValue] = Dictionary(uniqueKeysWithValues: zip(authors, authorSortArray))
        
        modifiedResponseJSON[Book.CodingKeys.cover.rawValue] = book.cover.relativePath
        modifiedResponseJSON[Book.CodingKeys.thumbnail.rawValue] = book.thumbnail.relativePath
        
        if modifiedResponseJSON[Book.CodingKeys.identifiers.rawValue] == nil {
            modifiedResponseJSON[Book.CodingKeys.identifiers.rawValue] = [:]
        }
        
        if modifiedResponseJSON[Book.CodingKeys.languages.rawValue] == nil {
            modifiedResponseJSON[Book.CodingKeys.languages.rawValue] = []
        }
        
        if modifiedResponseJSON[Book.CodingKeys.tags.rawValue] == nil {
            modifiedResponseJSON[Book.CodingKeys.tags.rawValue] = []
        }
        
        let titleSort = bookMetadata["sort"]
        modifiedResponseJSON[Book.CodingKeys.titleSort.rawValue] = titleSort
        
        if let rating = modifiedResponseJSON[Book.CodingKeys.rating.rawValue] as? Int {
            // Just like changing the rating seems to actually set this to half of what you send in, this
            // particular response is double what the actual rating is.
            modifiedResponseJSON[Book.CodingKeys.rating.rawValue] = rating / 2
        }
        
        let modifiedResponseData = try JSONSerialization.data(withJSONObject: modifiedResponseJSON)
        let parsedResponse = try JSONDecoder().decode(Book.self, from: modifiedResponseData)
        return parsedResponse
    }
}
