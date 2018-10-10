//
//  Book.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/8/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Foundation

// TODO: see if any / all of these need to be optional?

public struct Book: ResponseSerializable {
    
    private enum CodingKeys: String, CodingKey {
        case applicationID = "application_id"
        case comments
        case cover
        case identifiers
        case languages
        case lastModified = "last_modified"
        case tags
        case thumbnail
        case title
        case titleSort = "title_sort"
        case authors
        case authorSortMap = "author_sort_map"
    }
    
    public let applicationID: Int
    public let authors: [Author]
    public let comments: String?
    public let cover: CoverEndpoint
    public let identifiers: [Identifier]
    public let languages: [String] // TODO: enum?
    public let lastModified: Date
    public let tags: [String]
    public let thumbnail: ThumbnailEndpoint
    public let title: Title
    
    public struct Author {
        public let name: String
        public let sort: String
    }
    
    public struct Identifier {
        public let name: String // TODO: enum? Google, ISBN, etc.?
        public let uniqueID: String
    }
    
    public struct Title {
        public let name: String
        public let sort: String
    }
    
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current // TODO: This doesn't seem to work, come back to this
        return formatter
    }()
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.applicationID = try container.decode(Int.self, forKey: .applicationID)
        
        let rawAuthors = try container.decode([String].self, forKey: .authors)
        let rawAuthorSortMap = try container.decode([String: String].self, forKey: .authorSortMap)
        self.authors = rawAuthors.map { Author(name: $0, sort: rawAuthorSortMap[$0] ?? $0) }
        
        self.comments = try container.decode(Optional<String>.self, forKey: .comments)
        self.cover = try container.decode(CoverEndpoint.self, forKey: .cover)
        
        let rawIdentifiers = try container.decode([String: String].self, forKey: .identifiers)
        self.identifiers = rawIdentifiers.map { Identifier(name: $0.key, uniqueID: $0.value) }
        
        self.languages = try container.decode([String].self, forKey: .languages)
        
        let rawLastModified = try container.decode(String.self, forKey: .lastModified)
        guard let lastModified = Book.dateFormatter.date(from: rawLastModified) else {
            throw CalibreError.message("Unexected date format")
        }
        self.lastModified = lastModified
        
        self.tags = try container.decode([String].self, forKey: .tags)
        
        let rawTitle = try container.decode(String.self, forKey: .title)
        let rawTitleSort = try container.decode(String.self, forKey: .titleSort)
        self.title = Title(name: rawTitle, sort: rawTitleSort)
        
        self.thumbnail = try container.decode(ThumbnailEndpoint.self, forKey: .thumbnail)
    }
}
