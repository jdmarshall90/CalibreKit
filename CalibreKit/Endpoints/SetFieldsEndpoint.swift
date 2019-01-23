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
    public typealias ParsedResponse = SetFields
    public let method: HTTPMethod = .post
    
    // TODO: Does this URL come back from the /books/ endpoint's response?
    public var relativePath: String {
        return "/cdb/set-fields/\(book.id)/"
    }
    
    // TODO: Write documentation for this enum and all sub-types/cases/properties
    public enum Change: Hashable {
        public enum Property: Hashable {
            case comments(String?)
            case identifiers([String: String]) // TODO: Can this be statically typed to the `Book.Identifier` struct?
            case languages([String]) // TODO: Can this be statically typed to the `Book.Language` struct?
            case publishedDate(Date?)
            case series([String: String]?) // TODO: Can this be statically typed to the `Book.Series` struct?
            case tags([String])
            case title(String?) // TODO: Can this be statically typed to the `Book.Title` struct?
            
            private static let dateFormatter: ISO8601DateFormatter = {
                let formatter = ISO8601DateFormatter()
                formatter.timeZone = TimeZone.current
                return formatter
            }()
            
            internal var parameters: Parameters? {
                switch self {
                case .comments(let comments):
                    return ["comments": comments as Any]
                case .identifiers(let identifiers):
                    return identifiers
                case .languages(let languages):
                    return ["languages": languages]
                case .publishedDate(let date):
                    guard let date = date else { return nil }
                    return ["pubdate": Property.dateFormatter.string(from: date)]
                case .series(let series):
                    return ["series": series?.keys.first as Any, "series_index": series?.values.first as Any]
                case .tags(let tags):
                    return ["tags": tags]
                case .title(let title):
                    return ["title": title as Any]
                }
            }
        }
        
        case noChange
        case change(Property)
        
        internal var parameters: Parameters? {
            switch self {
            case .noChange:
                return nil
            case .change(let property):
                return property.parameters
            }
        }
    }
    
    public var parameters: Parameters? {
        // TODO: Remove this comment after you fix the data for this book
//        9780345806796, Google -- original ISBN of book id 1 before you started testing out the API
        
        // TODO: Refactor this to reference `self.changes`
        return [
            "changes": [
                "title": "", //'Salem's LotAPPTESTTAKE2", // empty string does same thing as nil: sets it to "Unknown"
                
                // TODO: Need to figure this one out
//                "title_sort": nil, // all of these appear to be nillable, but I can't get this field to work ... ? come back to it
                
                // TODO: Create a matching Change.Property enum case for this one
                "rating": 8, // this seems to actually set this to half of what you send in. look into Calibre code to confirm
                
                // TODO: Create a matching Change.Property enum case for this one
                "authors": nil, // empty array, nil, and array of just "": sets it to "Unknown"
                
                // TODO: Need to figure this one out
//                "author_sort": ["something": "bob"], // can't get this one working? come back to it
                
                "series": "CalibreKit", //* // empty string does same thing as nil: nils it out
                "series_index": nil, //* // ignored and set to nil if series is nil or empty. if this is nil and series is not, this is actually set to 1
                "comments": "", //* // both nil and empty string set it to null
                "pubdate": "", //* // both nil and empty string set it to null
                "languages": "Telugu", //* // either a string, or string array works, non valid language or language code and it nulls it out
                "identifiers": ["aoeu": "aoeu"], //* // seems to take anything as long as it's a [String: String] with keys and values not empty
                "tags": nil //* // either a string, or string array works, nil or [] empties it out
            ],
            
            // TODO: Need a way for client to pass this in
            "loaded_book_ids": [
//                1 // this doesn't return the same data as the next call to fetch book details?
            ],
            
            // TODO: Need a way for client to pass this in?
            "all_dirtied": true // what happens if you pass this to a server that doesn't support it (since it's a brand new field)? it works. is there a way to query server for calibre version?
        ]
    }
    
    public var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    public let book: BookEndpoint
    public let changes: Set<Change>

    public init(book: BookEndpoint, changes: Set<Change>) {
        self.book = book
        self.changes = changes
    }
}
