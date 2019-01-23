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

// TODO: Move this to separate file
public struct SetFields: ResponseSerializable {
    //
}

public struct SetFieldsEndpoint: Endpoint {
    public typealias ParsedResponse = SetFields
    public let method: HTTPMethod = .post
    
    // TODO: Does this URL come back from the /books/ endpoint's response?
    public var relativePath: String {
        return "/cdb/set-fields/\(id)/"
    }
    
    public var parameters: Parameters? {
//        9780345806796, Google
        
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        
        return [
            "changes": [
                "title": "", //'Salem's LotAPPTESTTAKE2", // empty string does same thing as nil: sets it to "Unknown"
//                "title_sort": nil, // all of these appear to be nillable, but I can't get this field to work ... ? come back to it
                "rating": 8, // this seems to actually set this to half of what you send in. look into Calibre code to confirm
                "authors": nil, // empty array, nil, and array of just "": sets it to "Unknown"
//                "author_sort": ["something": "bob"], // can't get this one working? come back to it
                "series": "CalibreKit", // empty string does same thing as nil: nils it out
                "series_index": nil, // ignored and set to nil if series is nil or empty. if this is nil and series is not, this is actually set to 1
                "comments": "", // both nil and empty string set it to null
                "pubdate": "", // both nil and empty string set it to null
                "languages": "Telugu", // either a string, or string array works, non valid language or language code and it nulls it out
                "identifiers": ["A": "a"], // seems to take anything as long as it's a [String: String] with keys and values not empty
                "tags": nil // either a string, or string array works, nil or [] empties it out
            ],
            "loaded_book_ids": [
//                1 // this doesn't return the same data as the next call to fetch book details?
            ],
            "all_dirtied": true // what happens if you pass this to a server that doesn't support it (since it's a brand new field)? it works. is there a way to query server for calibre version?
        ]
    }
    
    public var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    // swiftlint:disable:next identifier_name
    public let id: Int
    
    // swiftlint:disable:next identifier_name
    public init(id: Int) {
        self.id = id
    }
}
