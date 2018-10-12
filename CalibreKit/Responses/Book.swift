//
//  Book.swift
//  CalibreKit
//
//  Created by Justin Marshall on 10/8/18.
//  Copyright © 2018 Justin Marshall. All rights reserved.
//

import Foundation

public struct Book: ResponseSerializable, Equatable {
    
    private enum CodingKeys: String, CodingKey {
        // swiftlint:disable:next identifier_name
        case id = "application_id"
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
    
    public static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
    
    // swiftlint:disable:next identifier_name
    public let id: Int
    public let authors: [Author]
    public let comments: String?
    public let cover: CoverEndpoint
    public let identifiers: [Identifier]
    public let languages: [Language]
    public let lastModified: Date
    public let tags: [String]
    public let thumbnail: ThumbnailEndpoint
    public let title: Title
    
    public struct Author {
        public let name: String
        public let sort: String
    }
    
    public enum Identifier {
        // swiftlint:disable identifier_name
        case isbn(String)
        case google(String)
        case other(source: String, uniqueID: String)
        // swiftlint:enable identifier_name
        
        private var serverValue: String? {
            switch self {
            case .isbn:
                return "isbn"
            case .google:
                return "google"
            case .other:
                return nil
            }
        }
        
        public var displayValue: String {
            switch self {
            case .isbn:
                return "ISBN"
            case .google:
                return "Google"
            case .other(let source, _):
                return source
            }
        }
        
        public var uniqueID: String {
            switch self {
            case .isbn(let uniqueID),
                 .google(let uniqueID),
                 .other(_, let uniqueID):
                return uniqueID
            }
        }
        
        internal init(source: String, uniqueID: String) {
            switch source {
            case Identifier.isbn("").serverValue:
                self = .isbn(uniqueID)
            case Identifier.google("").serverValue:
                self = .google(uniqueID)
            default:
                self = .other(source: source, uniqueID: uniqueID)
            }
        }
    }
    
    public enum Language: ResponseSerializable {
        case english
        case latin
        case russian
        case spanish
        // swiftlint:disable:next identifier_name
        case other(String)
        
        private var serverValue: String? {
            switch self {
            case .english:
                return "eng"
            case .latin:
                return "lat"
            case .russian:
                return "rus"
            case .spanish:
                return "spa"
            case .other:
                return nil
            }
        }
        
        public var displayValue: String {
            switch self {
            case .english:
                return "English"
            case .latin:
                return "Latin"
            case .russian:
                return "Russian"
            case .spanish:
                return "Spanish"
            case .other(let language):
                return language
            }
        }
        
        public init(from decoder: Decoder) throws {
            let rawValue = try decoder.singleValueContainer().decode(String.self)
            switch rawValue {
            case Language.english.serverValue:
                self = .english
            case Language.latin.serverValue:
                self = .latin
            case Language.russian.serverValue:
                self = .russian
            case Language.spanish.serverValue:
                self = .spanish
            default:
                self = .other(rawValue)
            }
        }
    }
    
    public struct Title {
        public let name: String
        public let sort: String
    }
    
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        
        let rawAuthors = try container.decode([String].self, forKey: .authors)
        let rawAuthorSortMap = try container.decode([String: String].self, forKey: .authorSortMap)
        self.authors = rawAuthors.map { Author(name: $0, sort: rawAuthorSortMap[$0] ?? $0) }
        
        self.comments = try container.decode(Optional<String>.self, forKey: .comments)
        self.cover = try container.decode(CoverEndpoint.self, forKey: .cover)
        
        let rawIdentifiers = try container.decode([String: String].self, forKey: .identifiers)
        self.identifiers = rawIdentifiers.map { Identifier(source: $0.key, uniqueID: $0.value) }
        
        self.languages = try container.decode([Language].self, forKey: .languages)
        
        let rawLastModified = try container.decode(String.self, forKey: .lastModified)
        guard let lastModified = Book.dateFormatter.date(from: rawLastModified) else {
            throw CalibreError.message("Unexected date format")
        }
        self.lastModified = lastModified
        
        self.tags = try container.decode([String].self, forKey: .tags)
        
        let rawTitle = try container.decode(String.self, forKey: .title)
        let rawTitleSort = try container.decode(Optional<String>.self, forKey: .titleSort)
        self.title = Title(name: rawTitle, sort: rawTitleSort ?? rawTitle)
        
        self.thumbnail = try container.decode(ThumbnailEndpoint.self, forKey: .thumbnail)
    }
}
