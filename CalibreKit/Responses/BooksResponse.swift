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
        
        /*
        "1": {
            "application_id": 1,
            "author_link_map": {
                "Stephen King": ""
            },
            "author_sort": "Unknown",
            "author_sort_map": {
                "Stephen King": "King, Stephen"
            },
            "authors": [
                "Stephen King"
            ],
            "category_urls": {
                "authors": {
                    "Stephen King": "/ajax/books_in/617574686f7273/32/Calibre_Library"
                },
                "languages": {},
                "publisher": {
                    "Doubleday": "/ajax/books_in/7075626c6973686572/31/Calibre_Library"
                },
                "series": {},
                "tags": {
                    "Fiction": "/ajax/books_in/74616773/31/Calibre_Library",
                    "Horror": "/ajax/books_in/74616773/32/Calibre_Library",
                    "Literary": "/ajax/books_in/74616773/33/Calibre_Library",
                    "Psychological": "/ajax/books_in/74616773/34/Calibre_Library",
                    "Suspense": "/ajax/books_in/74616773/36/Calibre_Library",
                    "Thrillers": "/ajax/books_in/74616773/35/Calibre_Library"
                }
            },
            "comments": "Ben Mears has returned to Jerusalem's Lot in hopes that exploring the history of the Marsten House, an old mansion long the subjec
        t of rumor and speculation, will help him cast out his personal devils and provide inspiration for his new book. But when two young boys venture into t
        he woods, and only one returns alive, Mears begins to realize that something sinister is at work--in fact, his hometown is under siege from forces of d
        arkness far beyond his imagination. And only he, with a small group of allies, can hope to contain the evil that is growing within the borders of this
        small New England town.  With this, his second novel, Stephen King established himself as an indisputable master of American horror, able to transform the old conceits of the genre into something fresh and all the more frightening for taking place in a familiar, idyllic locale.",
            "cover": "/get/cover/1/Calibre_Library",
            "format_metadata": {},
            "formats": [],
            "identifiers": {
                "google": "4ASPDQAAQBAJ",
                "isbn": "9780345806796"
            },
            "languages": [
                "eng"
            ],
            "last_modified": "2018-10-06T16:10:37+00:00",
            "main_format": null,
            "other_formats": {},
            "pubdate": "2013-10-15T22:44:20+00:00",
            "publisher": "Doubleday",
            "rating": 0.0,
            "series": null,
            "series_index": null,
            "tags": [
                "Fiction",
                "Horror",
                "Literary",
                "Psychological",
                "Thrillers",
                "Suspense"
            ],
            "thumbnail": "/get/thumb/1/Calibre_Library",
            "timestamp": "2018-10-04T22:44:18+00:00",
            "title": "Salem's Lot",
            "title_sort": "Salem's Lot",
            "user_categories": {},
            "user_metadata": {
                "#isbn": {
                    "#extra#": null,
                    "#value#": "9780345806796",
                    "category_sort": "value",
                    "colnum": 1,
                    "column": "value",
                    "datatype": "composite",
                    "display": {
                        "composite_sort": "text",
                        "composite_template": "{identifiers:select(isbn)}",
                        "contains_html": false,
                        "description": "",
                        "make_category": false,
                        "use_decorations": 0
                    },
                    "is_category": false,
                    "is_csp": false,
                    "is_custom": true,
                    "is_editable": true,
                    "is_multiple": null,
                    "is_multiple2": {},
                    "kind": "field",
                    "label": "isbn",
                    "link_column": "value",
                    "name": "ISBN",
                    "rec_index": 22,
                    "search_terms": [
                        "#isbn"
                    ],
                    "table": "custom_column_1"
                }
            },
        "uuid": "617d357f-4838-492e-bb22-e652a3b4f63a"
        }
        */
        
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