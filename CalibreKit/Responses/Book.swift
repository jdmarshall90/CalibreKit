//
//  Book.swift
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

import Foundation

public struct Book: ResponseSerializable {
    
    fileprivate enum CodingKeys: String, CodingKey {
        // swiftlint:disable:next identifier_name
        case id = "application_id"
        case addedOn = "timestamp"
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
        case publishedDate = "pubdate"
        case rating
        case series
        case seriesIndex = "series_index"
    }
    
    // swiftlint:disable:next identifier_name
    public let id: Int
    public let addedOn: Date?
    public let authors: [Author]
    public let comments: String?
    public let cover: CoverEndpoint
    public let identifiers: [Identifier]
    public let languages: [Language]
    public let lastModified: Date?
    public let tags: [String]
    public let thumbnail: ThumbnailEndpoint
    public let title: Title
    public let publishedDate: Date?
    public let rating: Rating
    public let series: Series?
    
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
    
    public enum Rating: Int, ResponseSerializable {
        case unrated
        case oneStar
        case twoStars
        case threeStars
        case fourStars
        case fiveStars
        
        public var displayValue: String {
            switch self {
            case .unrated:
                return "⭒⭒⭒⭒⭒"
            case .oneStar:
                return "⭑⭒⭒⭒⭒"
            case .twoStars:
                return "⭑⭑⭒⭒⭒"
            case .threeStars:
                return "⭑⭑⭑⭒⭒"
            case .fourStars:
                return "⭑⭑⭑⭑⭒"
            case .fiveStars:
                return "⭑⭑⭑⭑⭑"
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawRating = try container.decode(Int.self)
            guard let rating = Rating(rawValue: rawRating) else {
                throw CalibreError.message("Expected rating of 0-5, but got \(rawRating).")
            }
            self = rating
        }
    }
    
    public struct Series {
        public let name: String
        public let index: Double
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.addedOn = try container.decodeDate(forKey: .addedOn)
        
        let rawAuthors = try container.decode([String].self, forKey: .authors)
        let rawAuthorSortMap = try container.decode([String: String].self, forKey: .authorSortMap)
        self.authors = rawAuthors.map { Author(name: $0, sort: rawAuthorSortMap[$0] ?? $0) }
        
        self.comments = try container.decode(Optional<String>.self, forKey: .comments)
        self.cover = try container.decode(CoverEndpoint.self, forKey: .cover)
        
        let rawIdentifiers = try container.decode([String: String].self, forKey: .identifiers)
        self.identifiers = rawIdentifiers.map { Identifier(source: $0.key, uniqueID: $0.value) }
        
        self.languages = try container.decode([Language].self, forKey: .languages)
        self.lastModified = try container.decodeDate(forKey: .lastModified)
        self.tags = try container.decode([String].self, forKey: .tags)
        
        let rawTitle = try container.decode(String.self, forKey: .title)
        let rawTitleSort = try container.decode(Optional<String>.self, forKey: .titleSort)
        self.title = Title(name: rawTitle, sort: rawTitleSort ?? rawTitle)
        
        self.thumbnail = try container.decode(ThumbnailEndpoint.self, forKey: .thumbnail)
        
        self.publishedDate = try container.decodeDate(forKey: .publishedDate)
        do {
            self.rating = try container.decode(Rating.self, forKey: .rating)
        } catch let error as CalibreError {
            throw CalibreError.message("Error in book \"\(title.name)\": " + error.localizedDescription)
        }
        
        if let seriesName = try container.decodeIfPresent(String.self, forKey: .series),
            let seriesIndex = try container.decodeIfPresent(Double.self, forKey: .seriesIndex) {
            self.series = Series(name: seriesName, index: seriesIndex)
        } else {
            self.series = nil
        }
    }
}

private extension KeyedDecodingContainer where Key == Book.CodingKeys {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    func decodeDate(forKey key: Key) throws -> Date? {
        let rawDate = try decode(String.self, forKey: key)
        let date = KeyedDecodingContainer<K>.dateFormatter.date(from: rawDate)
        return date
    }
}
